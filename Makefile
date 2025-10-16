# Makefile for auth-user-service

.PHONY: help build run test clean migrate docker-build docker-up docker-down

# Default target
help:
	@echo "Available commands:"
	@echo "  build        - Build the application"
	@echo "  run          - Run the application"
	@echo "  test         - Run tests"
	@echo "  clean        - Clean build artifacts"
	@echo "  migrate      - Run database migrations"
	@echo "  docker-build - Build Docker image"
	@echo "  docker-up    - Start services with Docker Compose"
	@echo "  docker-down  - Stop services with Docker Compose"

# Build the application
build:
	go build -o bin/auth-service cmd/server/main.go

# Run the application
run:
	go run cmd/server/main.go

# Run tests
test:
	go test -v ./...

# Run tests with coverage
test-coverage:
	go test -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out

# Clean build artifacts
clean:
	rm -rf bin/
	rm -f coverage.out

# Run database migrations
migrate:
	migrate -path migrations -database "postgres://user:password@localhost:5432/auth_service?sslmode=disable" up

# Run database migrations down
migrate-down:
	migrate -path migrations -database "postgres://user:password@localhost:5432/auth_service?sslmode=disable" down

# Build Docker image
docker-build:
	docker build -t auth-service:latest .

# Start services with Docker Compose
docker-up:
	docker-compose up -d

# Stop services with Docker Compose
docker-down:
	docker-compose down

# View logs
logs:
	docker-compose logs -f app

# Install dependencies
deps:
	go mod download
	go mod tidy

# Format code
fmt:
	go fmt ./...

# Lint code
lint:
	golangci-lint run

# Install tools
install-tools:
	go install github.com/golang-migrate/migrate/v4/cmd/migrate@latest
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

