# Microservice Starter Template

Direktori `services/` berisi starter template untuk microservices domain e-commerce.

Struktur yang disarankan:

- `services/identity`
- `services/catalog`
- `services/inventory`
- `services/order`
- `services/payment`
- `services/notification`

Setiap service sebaiknya menyertakan:
- `README.md` deskripsi singkat.
- `src/index.ts` HTTP bootstrap sederhana.
- `Dockerfile` build image.
- `package.json` dan `tsconfig.json` jika menggunakan Node.js + TypeScript.

Gunakan `services/microservice-template/` sebagai acuan implementasi basis service.
