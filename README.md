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

## Estado de validación (23/11/2026)

Ejecutado contra PostgreSQL 17 (`postgres:17-alpine` en Docker), base vacía:

| Comprobación | Resultado |
|---|---|
| `npm run migrate` sobre base vacía, y una segunda vez | aplica `001_schema.sql`; la segunda vez no repite |
| Tablas y FK creadas | 58 tablas, 90 FOREIGN KEY |
| FK huérfana y `code` duplicado | rechazados por la base |
| `UPDATE`/`DELETE` sobre `document_versions` | rechazados por el disparador `immutable_row()` |
| `npm test` (dominio compartido) | 26/26 |
| `npm run test:provider` | 1/1 |
| `npm run seed`, `npm run check`, `/api/health` | correcto |
| Recorrido completo en navegador con `sigd-sistema` sobre esta base (plan, envío, aprobación, informe, evidencia, Administración, Reportes) | 11/11 pasos; en la base quedan plan aprobado, informe en borrador, 2 versiones y 1 evidencia |

No se probaron carga concurrente de 114 usuarios ni un servidor gestionado en la nube.

El modelo y sus fuentes editables están en `modelo/`; el diagrama relacional oficial es `modelo/diagrama_relacional/SIGD_Diagrama_Relacional.pdf`. Semanas efectivas, carga nominal, máximo semanal y umbral de reprobación se configuran por periodo. Por acuerdo del equipo (22/11) el periodo semilla aplica 40 h semanales como máximo obligatorio al enviar el plan; el resto de valores son ejemplos que requieren ratificación institucional.
