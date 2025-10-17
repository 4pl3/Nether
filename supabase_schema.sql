-- Supabase schema for Nether S.A.C. app
-- Habilitar extensiones (por si no están activas)
create extension if not exists "pgcrypto";

-- TABLAS
create table if not exists personas (
  id uuid primary key default gen_random_uuid(),
  nombres_completos text not null,
  dni text not null,
  celular text,
  ruc text,
  direccion text,
  cuenta_bancaria text,
  banco text,
  created_at timestamptz not null default now(),
  created_by uuid references auth.users(id) on delete set null
);

create table if not exists proveedores_bienes (
  id uuid primary key default gen_random_uuid(),
  nombre_proveedor text not null,
  nombre_empresa text,
  ruc text not null,
  celular text,
  provee text,
  created_at timestamptz not null default now(),
  created_by uuid references auth.users(id) on delete set null
);

create table if not exists proveedores_servicios (
  id uuid primary key default gen_random_uuid(),
  nombre_proveedor text not null,
  nombre_empresa text,
  ruc text not null,
  celular text,
  servicio text,
  created_at timestamptz not null default now(),
  created_by uuid references auth.users(id) on delete set null
);

-- RLS
alter table personas enable row level security;
alter table proveedores_bienes enable row level security;
alter table proveedores_servicios enable row level security;

-- Políticas
-- Lectura: todos los usuarios autenticados pueden ver (útil cuando es una base común de la empresa).
create policy personas_select on personas for select to authenticated using (true);
create policy bienes_select on proveedores_bienes for select to authenticated using (true);
create policy servicios_select on proveedores_servicios for select to authenticated using (true);

-- Inserción: el registro debe ser creado por el propio usuario.
create policy personas_insert on personas for insert to authenticated with check (created_by = auth.uid());
create policy bienes_insert on proveedores_bienes for insert to authenticated with check (created_by = auth.uid());
create policy servicios_insert on proveedores_servicios for insert to authenticated with check (created_by = auth.uid());

-- Actualización/Eliminación: sólo quien lo creó puede modificar/borrar.
create policy personas_update on personas for update to authenticated using (created_by = auth.uid()) with check (created_by = auth.uid());
create policy bienes_update on proveedores_bienes for update to authenticated using (created_by = auth.uid()) with check (created_by = auth.uid());
create policy servicios_update on proveedores_servicios for update to authenticated using (created_by = auth.uid()) with check (created_by = auth.uid());

create policy personas_delete on personas for delete to authenticated using (created_by = auth.uid());
create policy bienes_delete on proveedores_bienes for delete to authenticated using (created_by = auth.uid());
create policy servicios_delete on proveedores_servicios for delete to authenticated using (created_by = auth.uid());

-- Índices útiles para búsqueda
create index if not exists idx_personas_q on personas using gin (
  to_tsvector('spanish', coalesce(nombres_completos,'') || ' ' || coalesce(dni,'') || ' ' || coalesce(ruc,'') || ' ' || coalesce(celular,'') || ' ' || coalesce(banco,'') || ' ' || coalesce(direccion,'') || ' ' || coalesce(cuenta_bancaria,''))
);
create index if not exists idx_bienes_q on proveedores_bienes using gin (
  to_tsvector('spanish', coalesce(nombre_proveedor,'') || ' ' || coalesce(nombre_empresa,'') || ' ' || coalesce(ruc,'') || ' ' || coalesce(celular,'') || ' ' || coalesce(provee,''))
);
create index if not exists idx_servicios_q on proveedores_servicios using gin (
  to_tsvector('spanish', coalesce(nombre_proveedor,'') || ' ' || coalesce(nombre_empresa,'') || ' ' || coalesce(ruc,'') || ' ' || coalesce(celular,'') || ' ' || coalesce(servicio,''))
);
