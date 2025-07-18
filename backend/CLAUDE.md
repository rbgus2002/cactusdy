# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Spring Boot backend application for "Group Study" - a collaborative study management platform. The project uses Spring Boot 2.7.11 with Java 11, MySQL for database, Redis for caching, and JWT authentication.

## Development Commands

### Build and Run
```bash
# Build the project
./gradlew build

# Run tests
./gradlew test

# Run the application (Spring Boot will start on port 8080)
./gradlew bootRun

# Build Docker image
docker build -t groupstudy-backend .

# Run with Docker Compose (includes MySQL and Redis)
docker-compose up -d
```

### Test Commands
```bash
# Run all tests
./gradlew test

# Run specific test class
./gradlew test --tests "ssu.groupstudy.domain.study.service.StudyServiceTest"

# Run tests with coverage
./gradlew test jacocoTestReport
```

## Architecture Overview

### Domain-Driven Design Structure
The application follows DDD principles with clear domain boundaries:

- **API Layer** (`api/`): REST controllers and request/response VOs
- **Domain Layer** (`domain/`): Business logic, entities, repositories, and services
- **Global Layer** (`global/`): Cross-cutting concerns (security, exceptions, utils)

### Key Domain Modules
- **Study**: Core study group management
- **User**: User authentication and profile management  
- **Round**: Study session rounds and participants
- **Task**: Task management (personal and group tasks)
- **Comment**: Comment system for discussions
- **Notice**: Announcement system
- **Notification**: FCM push notifications

### Technology Stack
- **Framework**: Spring Boot 2.7.11, Spring Security, Spring Data JPA
- **Database**: MySQL (production), H2 (testing)
- **Cache**: Redis
- **Authentication**: JWT tokens
- **Documentation**: Swagger/OpenAPI 3
- **Messaging**: Firebase Cloud Messaging (FCM)
- **Cloud**: AWS S3 for file storage
- **External APIs**: CoolSMS for SMS, Notion API for feedback

## Key Patterns and Conventions

### Entity Design
- All entities extend `BaseEntity` or `BaseWithSoftDeleteEntity`
- Uses JPA auditing for create/modify timestamps
- Timezone: Asia/Seoul

### Authentication Flow
- JWT-based authentication with refresh tokens
- Security configuration in `SecurityConfig.java`
- Protected endpoints under `/api/**` require USER role
- Auth endpoints under `/auth/**` are public

### Exception Handling
- Global exception handler in `GlobalExceptionHandler`
- Custom `BusinessException` for domain-specific errors
- Standardized error responses via `ErrorResVo`

### API Response Format
- Consistent response structure using `ResVo`, `DataResVo`, `ErrorResVo`
- All responses include status codes and standardized error messages

## Configuration Profiles

- **local**: Development with local MySQL/Redis
- **prod**: Production with containerized services
- **test**: Testing with H2 in-memory database

## Database and Migrations

- JPA with Hibernate DDL validation in production
- Database migrations should be handled carefully
- Connection pooling and batch fetch optimization configured

## Testing Strategy

- Unit tests for services and repositories
- Integration tests for controllers
- Test utilities in `domain.common` package
- H2 database for testing isolation

## Important Notes

- Never commit sensitive data (API keys, secrets) - use environment variables
- FCM service account key is loaded from `studygroup-fcm.json`
- All timestamps use Asia/Seoul timezone
- CORS is configured to allow all origins (consider restricting in production)
- Swagger UI available at `/api-docs`