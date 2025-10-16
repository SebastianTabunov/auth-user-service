## API Reference

### Health
- GET /health
  - 200 OK: { "status": "ok", "database": "connected", "redis": "connected" }

### Auth
- POST /auth/register
  - Body: { email, password, firstName, lastName }
  - 201 Created: { token, email, id }
- POST /auth/login
  - Body: { email, password }
  - 200 OK: { token, email, id }
- POST /auth/refresh (requires Authorization: Bearer <token>)
  - 200 OK: { token, email, id }
- POST /auth/logout (requires Authorization)
  - 200 OK: { message }

### User
- GET /api/user/profile (requires Authorization)
  - 200 OK: Profile object
- PUT /api/user/profile (requires Authorization)
  - Body: { firstName, lastName, phone, address }
  - 200 OK: { status: "profile updated" }

### Orders
- GET /api/orders (requires Authorization)
  - 200 OK: [ Order ]
- GET /api/orders/{id} (requires Authorization)
  - 200 OK: Order
- POST /api/orders (requires Authorization)
  - Body: { title, description, price }
  - 201 Created: Order

### CORS
- Production allows only `https://saynomore.ru`.
