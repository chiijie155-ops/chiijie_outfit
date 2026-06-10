# CI/CD & OpenAPI Reference

Dokumen ringkas untuk pipeline GitHub Actions dan kontrak OpenAPI di repository ini.

## 1. GitHub Actions CI/CD

File: `.github/workflows/ci-cd.yml`

Fungsi utama:
- `lint-test-build`: install dependencies, lint, unit test, dan build artefak.
- `docker-image`: build dan push Docker image ke GitHub Container Registry.
- `deploy-staging`: deploy manifest Kubernetes ke cluster staging.
- `smoke-test`: jalankan smoke test setelah deploy staging.

Catatan:
- Gunakan secret `KUBE_CONFIG_DATA` untuk kubeconfig base64.
- Gunakan `GITHUB_TOKEN` untuk login container registry.
- Sesuaikan nama deployment dan path manifest di `infra/k8s/base`.

## 2. Kontrak OpenAPI

File: `openapi-draft.yaml`

Cakupan draft:
- Identity: login, register, refresh token, profile.
- Catalog: products listing dan detail.
- Inventory: snapshot varian stock.
- Order: create order, retrieve order.
- Payment: create payment intent, webhook handler.
- Notification: email request.

Gunakan file ini sebagai basis:
- pembuatan server stub
- dokumentasi API
- test contract
- client SDK generation

## 3. Local Development

File: `docker-compose.yml`

- Jalankan `docker compose up --build` untuk memulai environment lokal:
  - PostgreSQL
  - Redis
  - Identity, Catalog, Inventory, Order, Payment, Notification service stubs
- Gunakan `./.env.example` sebagai template environment variables.

## 4. OpenAPI Stub Generator

Folder: `openapi-server-stub/`

- `scripts/generate-openapi-stub.js` membuat `openapi-server-stub/src/generated-routes.ts` dari `openapi-draft.yaml`.
- Jalankan dari root: `npm run generate-openapi-stub`
- Atau dari `openapi-server-stub`: `npm run generate`
- Setelah generate, jalankan stub server dengan `npm run dev` di folder `openapi-server-stub`.

## 3. Infra Kubernetes Minimal

Direktori: `infra/k8s/base`

Isi manifest:
- `namespace.yaml`: namespace `ecommerce`
- `deployment.yaml`: Deployment backend dengan strategy rolling update
- `service.yaml`: ClusterIP service untuk backend
- `ingress.yaml`: contoh Ingress dengan TLS dan NGINX annotation
- `kustomization.yaml`: kustomize manifest collection

Petunjuk:
- Sesuaikan image registry dan secret nama.
- Pastikan secret `ecommerce-secrets` berisi `database_url` dan `stripe_secret_key`.
- Pastikan TLS secret `ecommerce-tls` tersedia untuk Ingress.

## 4. Diagram Arsitektur

PlantUML source: `architecture-diagram.puml`
- Output PNG: `architecture-diagram.png`
- Output ASCII: `architecture-diagram.atxt`

Gunakan diagram ini sebagai bahan komunikasi arsitektur antara tim engineering dan stakeholder.
