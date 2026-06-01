# Gardenia Infra

Infrastructure and local runbooks for [Gardenia](https://github.com/sisques-labs/gardenia-api).

## Alpha stack (Docker Compose)

Runs the published **alpha** images from Docker Hub:

| Service  | Image                         | URL (defaults)              |
| -------- | ----------------------------- | --------------------------- |
| API      | `sisqueslabs/gardenia-api:alpha`  | http://localhost:3000/api   |
| Web      | `sisqueslabs/gardenia-web:alpha`  | http://localhost:8080     |
| Postgres | `postgres:16-alpine`          | internal only               |

The alpha web image is a **Next.js** standalone server (container port **3000**, mapped to host `WEB_PORT`, default 8080). Build it with `NEXT_PUBLIC_API_URL=http://localhost:3000/api` and `NEXT_PUBLIC_GRAPHQL_URL=http://localhost:3000/graphql` so the browser can reach the API on the host-mapped port (see `.env.alpha.example`).

### Quick start

```bash
cp .env.alpha.example .env.alpha
docker compose -f docker-compose.alpha.yml --env-file .env.alpha up -d
```

Open http://localhost:8080 (app) and http://localhost:3000/docs (Swagger).

### Stop and reset data

```bash
docker compose -f docker-compose.alpha.yml --env-file .env.alpha down
docker compose -f docker-compose.alpha.yml --env-file .env.alpha down -v   # also removes Postgres volume
```

### Notes

- **`DATABASE_SYNCHRONIZE=true`** is enabled by default so the API can create the schema without a migration step inside the slim runtime image. Turn it off in `.env.alpha` if you manage schema with TypeORM migrations instead. Requires an API image that honours this env var (see [gardenia-api `postgres.config`](https://github.com/sisques-labs/gardenia-api/blob/main/src/core/config/postgres.config.ts)).
- **`NODE_ENV=development`** is set on the API service so HTTP refresh cookies work locally (the image defaults to `production`, which sets `Secure` cookies).
- Change **`JWT_SECRET`** (and Postgres credentials) before exposing this stack beyond your machine.

### Image requirements

The API runtime image must ship production `node_modules` (Nest webpack keeps packages like `@nestjs/core` external). If `sisqueslabs/gardenia-api:alpha` crashes with `Cannot find module '@nestjs/core'`, publish a new alpha build from an updated [gardenia-api Dockerfile](https://github.com/sisques-labs/gardenia-api/blob/main/Dockerfile).
