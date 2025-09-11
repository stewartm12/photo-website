# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a full-stack photographer portfolio application with two main services:

- **Web Service** (`services/web/`): Next.js 15 frontend with React 19, Tailwind CSS v4, TypeScript, and shadcn/ui components
- **API Service** (`services/api/`): Ruby on Rails 8 backend with PostgreSQL, GraphQL API, and admin portal functionality

The application uses Docker Compose for local development with separate containers for web, API, and PostgreSQL.

## Common Development Commands

### Docker Development
```bash
# Start all services
docker-compose up --build

# Access Rails container
docker exec -it photo-website-api-1 bash

# Access Next.js container
docker exec -it photo-website-web-1 sh
```

### Next.js (Web Service)
```bash
# Development mode with Turbopack
npm run dev

# Production build
npm run build

# Start production server
npm run start

# Linting
npm run lint
```

### Rails (API Service)
```bash
# Database setup (handled automatically by entrypoint.sh)
rails db:setup
rails db:seed

# Generate encryption keys
bin/rails db:encryption:init

# Run tests
bundle exec rspec

# Code style checking
bundle exec rubocop

# Rails console
rails console

# Start Rails server
rails server
```

## Project Structure

### Web Service Architecture
- **App Router**: Uses Next.js 15 App Router with TypeScript
- **UI Components**: shadcn/ui components in `src/components/ui/`
- **Page Components**: Route-specific components in `src/app/[route]/components/`
- **Root Components**: Shared layout components in `src/app/root-components/`
- **GraphQL**: Client queries and mutations in `src/graphql/`
- **Types**: TypeScript definitions in `src/types/`
- **Utilities**: Helper functions in `src/utils/` and `src/lib/`
- **Context**: React Context providers in `src/context/`

### API Service Architecture
- **GraphQL API**: Primary API interface with auto-generated documentation
- **Rails Admin Portal**: Internal management interface for photographers
- **Models**: ActiveRecord models with encryption support
- **Authentication**: Rails 8 built-in authentication with API tokens
- **Jobs**: Background job processing with Solid Queue
- **Mailers**: Email functionality via Mailgun integration
- **Specs**: RSpec tests with FactoryBot and comprehensive test suite

## Environment Configuration

Required environment files in `config/environment/`:
- `nextjs.local.env` - Next.js environment variables
- `rails.local.env` - Rails environment variables including:
  - Rails encryption keys (generate with `bin/rails db:encryption:init`)
  - Mailgun API credentials
  - Mapbox access token
- `db.env` - PostgreSQL database configuration

## Key Features

### Web Frontend
- Photo galleries with masonry layout
- Appointment booking system with location search
- Services showcase with package pricing
- Responsive design with mobile navigation
- Dark mode support via next-themes

### Rails Backend  
- GraphQL API with queries for galleries, appointments, locations
- Photo and gallery management with Active Storage (AWS S3)
- Appointment scheduling with email notifications
- User authentication and store management
- Invoice generation and PDF receipts
- Background job processing for email and photo processing

## Testing

### Rails Testing
- **Framework**: RSpec with FactoryBot for test data
- **Coverage**: SimpleCov for code coverage reporting  
- **Test Types**: Models, controllers, GraphQL resolvers, jobs, mailers
- **Database**: DatabaseCleaner for test isolation
- **Mocking**: WebMock for external API testing

### Code Quality
- **Rails**: RuboCop with rails-omakase configuration, single quotes enforced
- **Next.js**: ESLint with next/core-web-vitals and TypeScript rules
- **Security**: Brakeman for Rails security scanning

## GraphQL Schema

The API exposes a GraphQL endpoint with key types:
- `Gallery` - Photo collections with metadata
- `Photo` - Individual photos with variants  
- `Appointment` - Booking system integration
- `Location` - Geographic data with Mapbox integration
- `Package` - Service offerings and pricing

## External Integrations

- **AWS S3**: Photo storage and CDN delivery
- **Mailgun**: Transactional email delivery
- **Mapbox**: Location services and map rendering
- **PostgreSQL**: Primary database with encryption support