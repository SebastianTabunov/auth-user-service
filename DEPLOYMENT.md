## Deployment Guide

### Prerequisites
- Docker and Docker Compose
- PostgreSQL and Redis (or use docker-compose for dev)
- Domain configured for your VPS

### Environment Variables
Required (production):
- APP_ENV=production
- PORT (e.g., 8080)
- DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME, DB_SSLMODE
- REDIS_URL (e.g., redis://user:pass@host:6379/0)
- JWT_SECRET (strong random string)
- CORS_ALLOWED_ORIGINS (optional; defaults to https://saynomore.ru in production)

### Build and Run with Docker
```bash
docker build -t auth-user-service:prod .
docker run --rm -p 8080:8080 \
  -e APP_ENV=production \
  -e PORT=8080 \
  -e DB_HOST=... -e DB_PORT=5432 -e DB_USER=... -e DB_PASSWORD=... -e DB_NAME=... -e DB_SSLMODE=disable \
  -e REDIS_URL=redis://redis:6379/0 \
  -e JWT_SECRET=your-strong-secret \
  -e CORS_ALLOWED_ORIGINS=https://saynomore.ru \
  auth-user-service:prod
```

### Healthcheck
- Container exposes `/health` on PORT.

### Migrations
- Migrations are executed on container start via `/app/scripts/migrate.sh`.

### Security Notes
- Use a strong JWT_SECRET and rotate periodically.
- Limit CORS to `https://saynomore.ru` in production.
- Dockerfile runs as non-root user (`appuser`).
