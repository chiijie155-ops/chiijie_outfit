# chiijie_outfit
Toko baju

## Dokumentasi Teknis
- `ENTERPRISE_ECOMMERCE_BLUEPRINT.md` - blueprint arsitektur dan implementasi skala besar.
- `README_PIPELINE_OPENAPI.md` - ringkasan pipeline CI/CD dan kontrak OpenAPI.
- `openapi-draft.yaml` - draft OpenAPI untuk service core.
- `architecture-diagram.puml`, `architecture-diagram.png`, `architecture-diagram.atxt` - diagram arsitektur.
- `infra/k8s/base/` - manifest Kubernetes minimal untuk deployment.
- `docker-compose.yml` - lingkungan lokal untuk semua service, Postgres, dan Redis.
- `openapi-server-stub/` - server stub generator berdasarkan draft OpenAPI.
- `scripts/generate-openapi-stub.js` - generator stub express routes.
- `sql/migrations/` - PostgreSQL schema migration.

