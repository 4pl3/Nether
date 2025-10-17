# Nether S.A.C. — Mini Base de Datos (Frontend + Supabase)

Este paquete te da **todo** para publicar una app web (estilo 4pl3) que permita registrar y buscar **Personal**, **Proveedores de bienes** y **Proveedores de servicios**.  
Frontend está listo para **GitHub Pages** y la base de datos corre en **Supabase** (PostgreSQL gestionado con Auth + RLS).

## 0) ¿Por qué no sólo GitHub?
GitHub Pages es hosting **estático** (sirve archivos). Para **guardar** datos hace falta un backend/API. Usamos **Supabase** porque:
- Gratis en plan inicial, rápido de crear.
- Tiene **Auth** (usuarios/contraseñas) y **RLS** (seguridad por filas).
- Cliente JS simple desde el navegador.

> Alternativas: Firebase/Firestore, Appwrite, PocketBase, etc. El frontend funcionaría similar cambiando el cliente.

---

## 1) Crea el proyecto en Supabase
1. Inicia sesión en [supabase.com](https://supabase.com) y crea un **Project**.
2. Ve a **Project → SQL editor** y pega el contenido de `supabase_schema.sql` → **Run**.
   - Crea tablas, habilita RLS y políticas de seguridad.
3. Ve a **Authentication → Providers** y **habilita Email con contraseña**.
4. En **Authentication → Users**, crea los usuarios de tu equipo (correo y contraseña).
5. En **Project Settings → API**, copia:
   - **Project URL** (ej. `https://xxxxx.supabase.co`)
   - **anon public key**

> (Opcional) En **Auth → Policies** puedes restringir dominios permitidos o revisar las políticas para que sólo usuarios autorizados vean la base.

---

## 2) Configura el frontend
1. Abre `index.html` y reemplaza en la sección `/* CONFIG */`:
   - `SUPABASE_URL` → tu URL de proyecto
   - `SUPABASE_ANON_KEY` → tu anon key
2. (Listo) El frontend usa **email+contraseña**. Desde la app podrás **logearte**, **crear registros**, **buscar**, **borrar** y **exportar CSV**.

---

## 3) Sube a GitHub Pages
1. Crea un repositorio (ej. `nether-db-app`) y sube **index.html**.
2. En **Settings → Pages**, set **Source** a `main` (root) y guarda.  
   Tu app quedará en `https://TU_USUARIO.github.io/nether-db-app`.
3. (Opcional) Agrega `CNAME` si usarás un dominio propio.

> **Importante:** No subas la *service_role key*. Sólo la `anon key` pública.

---

## 4) Uso
- Ingresa con el correo/contraseña que creaste en Supabase Auth.
- **Atajos** (columna izquierda) para abrir formularios de *Personal*, *Bienes*, *Servicios*.
- **Buscar** filtra en tiempo real por nombre, DNI, RUC, celular, empresa, etc.
- **Exportar CSV** descarga un `.txt` con 3 bloques (personas, bienes y servicios).

**RLS (seguridad):**
- Cualquiera **autenticado** puede **ver** (útil para que toda la empresa consulte).
- Sólo el **creador** de un registro puede **editar/borrar** (se puede ajustar en SQL).

---

## 5) Personalización
- Cambia estilos en `:root` (colores/fuentes) dentro de `index.html`.
- Puedes añadir edición en línea (update) siguiendo el patrón de `delRow(...)` y `supabase.from(...).update(...)`.
- Si quieres que **sólo usuarios de Nether** vean datos, cambia las políticas `select` para chequear un campo `org` o un dominio de correo.

---

## 6) Problemas comunes
- **No conecta / CORS**: Asegúrate de estar usando la `anon key` correcta. Supabase permite orígenes públicos por defecto; para Auth por enlace mágico se requieren redirect URLs, pero aquí usamos email+contraseña.
- **No veo datos**: Verifica que estás **logueado** y que las políticas RLS no bloqueen la lectura.
- **Eliminar falla**: Recuerda que sólo el **created_by** puede borrar su propio registro (política segura por defecto).

---

Hecho con cariño para **Nether S.A.C.**. ¡A producir! 🚀
