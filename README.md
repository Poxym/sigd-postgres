# SIGD PostgreSQL

Implementación física del modelo relacional corregido: 58 tablas, 90 FK, índices, unicidad, controles de rangos y protección de versiones históricas. Las migraciones se generan desde el mismo `modelo/schema.json` que usa el servicio de dominio.

## Arranque

Requiere Node.js 24 o posterior y PostgreSQL 17. Con Docker iniciado:

```powershell
Copy-Item .env.example .env
# Cambiar POSTGRES_PASSWORD y DATABASE_URL en .env.
docker compose up -d
npm.cmd install
npm.cmd run migrate
npm.cmd run seed
npm.cmd start
```

El comando `migrate` aplica cada archivo una sola vez y registra su nombre en `schema_migrations`. Docker conserva los datos en el volumen `pgdata`.

La API se abre en `http://127.0.0.1:4203/api/health`; este proyecto de base de datos no sirve la interfaz completa. El proyecto `sigd-sistema` incluye el frontend y puede apuntar a esta misma base con `DB_PROVIDER=postgres`.

```powershell
npm.cmd test
npm.cmd run test:provider
npm.cmd run check
```

`seed` crea datos sintéticos cuando `SIGD_DEMO=1`. No incluye transcripciones, conversaciones privadas ni datos reales de docentes. Las credenciales de prueba se documentan en el proyecto del sistema; no usarlas en producción.

## Persistencia y reglas

El adaptador conserva columnas nativas de PostgreSQL y parametriza sus consultas. Cada transacción usa un único cliente del pool, comprueba integridad y aplica solamente los cambios de las filas. Un bloqueo transaccional serializa las escrituras del repositorio central. Ver [transacciones en node-postgres](https://node-postgres.com/features/transactions).

`document_versions`, `catalog_versions` y `audit_events` tienen protección de inmutabilidad. Las FK restringen eliminaciones y son diferibles para permitir la inserción transaccional de relaciones cíclicas. Las restricciones temporales y la prohibición de autoaprobar se comprueban en el servicio. Los archivos de evidencia quedan fuera de las tablas.

Los documentos conservan JSONB para su contenido congelado y, a la vez, proyecciones relacionales de secciones, registros y valores. La proyección se actualiza en la misma transacción. Las lecturas históricas usan la instantánea congelada.

## Estado de validación

Las pruebas del dominio compartido y de persistencia SQLite fueron ejecutadas en el espacio de trabajo. La migración y el adaptador PostgreSQL no pudieron ejecutarse allí: Docker estaba apagado y no había servidor PostgreSQL conectado. `test:provider` comprueba el adaptador cuando la base está disponible. No se presenta esta limitación como una prueba aprobada.

El modelo y sus fuentes editables están en `modelo/`. Las reglas de 40 horas, semanas efectivas y umbral de reprobación se parametrizan; los ejemplos requieren ratificación institucional.
