# SIGD · Base de datos PostgreSQL

Esquema relacional del Sistema Integral de Gestión Docente (SIGD): 58 tablas y 90 claves foráneas, organizadas en 7 dominios (estructura académica, identidad docente, seguridad, catálogos por periodo, documentos, revisión y reportes).

## Diagrama relacional

- `docs/diagrama-relacional/SIGD_Diagrama_Relacional.pdf`: portada con la leyenda, vista general y una lámina detallada por dominio. Usa notación pata de gallo y es vectorial, así que se puede ampliar sin perder calidad.
- `docs/diagrama-relacional/svg/`: cada lámina en SVG.
- `docs/DICCIONARIO.md` y `docs/schema.json`: diccionario de datos y la definición fuente del modelo.

## Levantar la base

```bash
cp .env.example .env          # cambia POSTGRES_PASSWORD y DATABASE_URL
docker compose up -d          # PostgreSQL 17; al iniciar aplica migrations/*.sql
```

Para aplicar las migraciones sobre una base existente:

```bash
npm install pg
node --env-file=.env migrate.mjs
```

`migrations/001_schema.sql` crea las tablas, las restricciones `UNIQUE`/`FOREIGN KEY` y los disparadores que hacen inmutables `document_versions` y `audit_events`.

El sistema que usa esta base está en el repositorio `sigd-sistema` (`DB_PROVIDER=postgres`).
