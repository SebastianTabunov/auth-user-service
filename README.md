# Auth User Service - Fixed Version

Это исправленная версия сервиса аутентификации и управления пользователями с улучшенной архитектурой, безопасностью и качеством кода.

## 🚀 Основные улучшения

### ✅ Исправленные проблемы
- **Удален дублирующий код** - убраны неиспользуемые файлы `postgres_repository.go` и `jwt.go`
- **Исправлена обработка ошибок** - все ошибки теперь логируются или обрабатываются корректно
- **Добавлена валидация** - централизованная валидация входных данных с помощью `go-playground/validator`
- **Улучшена безопасность** - добавлена валидация паролей, rate limiting, улучшенная обработка JWT
- **Исправлены миграции** - убрано дублирование полей между таблицами
- **Добавлены транзакции** - атомарные операции обновления профилей
- **Graceful shutdown** - корректное завершение работы сервера

### 🔒 Безопасность
- Валидация паролей (минимум 8 символов, 3 из 4 типов символов)
- Rate limiting для auth эндпоинтов (10 запросов в минуту)
- Улучшенная обработка JWT токенов
- Валидация email адресов
- Защита от SQL инъекций

### 🏗️ Архитектура
- Чистая архитектура с разделением на слои
- Интерфейсы для всех компонентов
- Централизованная конфигурация
- Улучшенная обработка ошибок
- Кэширование с Redis

## 📁 Структура проекта

```
auth-user-service-fixed/
├── cmd/server/           # Точка входа приложения
├── internal/
│   ├── auth/            # Модуль аутентификации
│   ├── config/          # Конфигурация
│   ├── database/        # Подключение к БД
│   ├── user/           # Модуль пользователей
│   ├── order/          # Модуль заказов
│   ├── redis/          # Redis клиент
│   └── validator/      # Валидация данных
├── migrations/         # Миграции БД
├── scripts/           # Скрипты
├── Dockerfile         # Docker образ
├── docker-compose.yml # Docker Compose
└── go.mod            # Зависимости
```

## 🛠️ Установка и запуск

### Локальная разработка

1. **Клонируйте репозиторий**
```bash
git clone <repository-url>
cd auth-user-service-fixed
```

2. **Установите зависимости**
```bash
go mod download
```

3. **Настройте переменные окружения**
```bash
cp .env.example .env
# Отредактируйте .env файл
```

4. **Запустите PostgreSQL и Redis**
```bash
docker-compose up -d db redis
```

5. **Запустите миграции**
```bash
make migrate
```

6. **Запустите приложение**
```bash
go run cmd/server/main.go
```

### Docker

```bash
# Запуск всех сервисов
docker-compose up -d

# Просмотр логов
docker-compose logs -f app

# Остановка
docker-compose down
```

## 🔧 Переменные окружения

```bash
# Сервер
PORT=8080

# База данных
DB_HOST=localhost
DB_PORT=5432
DB_USER=user
DB_PASSWORD=password
DB_NAME=auth_service
DB_SSLMODE=disable

# Redis
REDIS_URL=redis://localhost:6379/0

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-in-production

# CORS
CORS_ALLOWED_ORIGINS=http://localhost:3000,https://your-site.com
```

## 📚 API Endpoints

### Аутентификация
- `POST /auth/register` - Регистрация пользователя
- `POST /auth/login` - Вход в систему
- `POST /auth/refresh` - Обновление токена (требует авторизации)
- `POST /auth/logout` - Выход из системы (требует авторизации)

### Пользователи
- `GET /api/user/profile` - Получить профиль (требует авторизации)
- `PUT /api/user/profile` - Обновить профиль (требует авторизации)

### Заказы
- `GET /api/orders` - Получить заказы пользователя (требует авторизации)
- `GET /api/orders/{id}` - Получить конкретный заказ (требует авторизации)
- `POST /api/orders` - Создать заказ (требует авторизации)

### Служебные
- `GET /health` - Проверка здоровья сервиса
- `GET /tilda/health` - Health check для Tilda
- `POST /tilda/webhook` - Webhook для Tilda

## 🔍 Примеры запросов

### Регистрация
```bash
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecurePass123!",
    "first_name": "John",
    "last_name": "Doe"
  }'
```

### Вход
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecurePass123!"
  }'
```

### Получение профиля
```bash
curl -X GET http://localhost:8080/api/user/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 🧪 Тестирование

```bash
# Запуск тестов
go test ./...

# Запуск с покрытием
go test -cover ./...

# Бенчмарки
go test -bench=. ./...
```

## 📊 Мониторинг

- Health check: `GET /health`
- Логирование всех запросов
- Метрики производительности
- Graceful shutdown

## 🔧 Разработка

### Добавление новых эндпоинтов

1. Создайте структуры запросов с валидацией
2. Добавьте методы в репозиторий
3. Реализуйте бизнес-логику в сервисе
4. Создайте обработчик
5. Зарегистрируйте роуты в `main.go`

### Миграции

```bash
# Создание новой миграции
migrate create -ext sql -dir migrations -seq migration_name

# Применение миграций
migrate -path migrations -database "postgres://user:pass@localhost/db?sslmode=disable" up

# Откат миграций
migrate -path migrations -database "postgres://user:pass@localhost/db?sslmode=disable" down
```

## 🚀 Production

### Рекомендации для production

1. **Измените JWT_SECRET** на случайную строку
2. **Настройте HTTPS** через reverse proxy (nginx)
3. **Используйте внешние БД** (RDS, Cloud SQL)
4. **Настройте мониторинг** (Prometheus, Grafana)
5. **Добавьте логирование** (ELK Stack)
6. **Настройте backup** БД
7. **Используйте secrets management**

### Docker в production

```bash
# Сборка production образа
docker build -t auth-service:latest .

# Запуск с production конфигурацией
docker run -d \
  --name auth-service \
  -p 8080:8080 \
  -e JWT_SECRET=your-production-secret \
  -e DB_HOST=your-db-host \
  auth-service:latest
```

## 📝 Changelog

### v2.0.0 (Fixed Version)
- ✅ Удален дублирующий код
- ✅ Исправлена обработка ошибок
- ✅ Добавлена валидация данных
- ✅ Улучшена безопасность
- ✅ Исправлены миграции БД
- ✅ Добавлены транзакции
- ✅ Graceful shutdown
- ✅ Rate limiting
- ✅ Улучшенная архитектура

## 🤝 Вклад в проект

1. Fork репозитория
2. Создайте feature branch
3. Внесите изменения
4. Добавьте тесты
5. Создайте Pull Request

## 📄 Лицензия

MIT License

