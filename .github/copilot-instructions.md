# Copilot Instructions

This is a monorepo containing a Medusa v2 e-commerce backend and a Next.js 15 storefront.

## Project Structure

- `sc-shop-backend/` - Medusa v2 backend (Node.js, TypeScript, PostgreSQL)
- `sc-shop-frontend/` - Next.js 15 storefront (React 19, Tailwind CSS)

## Commands

### Backend (`sc-shop-backend/`)

```bash
pnpm dev          # Start development server
pnpm build        # Build for production
pnpm migrate      # Run database migrations
pnpm seed         # Seed database

# Tests
pnpm test:unit                    # Unit tests
pnpm test:integration:http        # HTTP integration tests
pnpm test:integration:modules     # Module integration tests

# Single test file
TEST_TYPE=unit NODE_OPTIONS=--experimental-vm-modules pnpm jest path/to/file.unit.spec.ts --runInBand
```

### Frontend (`sc-shop-frontend/`)

```bash
pnpm dev    # Start dev server (port 8000)
pnpm build  # Build for production
pnpm lint   # ESLint
```

## Architecture

### Backend (Medusa v2)

The backend follows Medusa v2's modular architecture:

- **`src/modules/`** - Custom modules with isolated business logic
  - Each module has `models/` (data models), `service.ts`, and `index.ts` (module definition)
  - `meilisearch/` - Search indexing service
  - `resend/` - Email notification provider
- **`src/api/`** - Custom REST endpoints using file-based routing
  - `store/` - Storefront APIs (public)
  - `admin/` - Admin APIs (authenticated)
  - Route files are `route.ts`, parameters use `[param]` directory syntax
- **`src/workflows/`** - Multi-step business processes with rollback support
  - Steps are defined in `steps/` subdirectory
- **`src/subscribers/`** - Event handlers (e.g., `product.created`, `order.placed`)
- **`src/jobs/`** - Scheduled background tasks (cron)
- **`src/links/`** - Cross-module data relationships

### Frontend (Next.js 15)

- **App Router** with dynamic `[countryCode]` routing for i18n
- **Route groups**: `(main)` for storefront, `(checkout)` for checkout flow
- **`src/modules/`** - Feature-organized React components
- **`src/lib/data/`** - Server actions for Medusa API calls
- Uses `@medusajs/js-sdk` for backend communication

### Services Integration

- **Meilisearch** - Product search, synced via subscribers
- **Redis** - Caching, event bus, workflow engine, locking
- **S3** - File storage
- **Resend** - Transactional emails
- **Stripe** - Payments

## Conventions

### Backend

- Services are resolved from Medusa container: `req.scope.resolve("moduleName")`
- Workflows must handle compensation (rollback) for failed steps
- Database changes require migrations: `pnpm medusa db:generate <module>` then `pnpm migrate`
- Test files: `*.unit.spec.ts` for unit, `*.spec.ts` in `integration-tests/http/` for HTTP tests

### Frontend

- Server components by default; use `"use client"` only when needed
- Data fetching via server actions in `src/lib/data/`
- Region/country context drives pricing and availability

## MCP Server

The Medusa documentation MCP server is available at `https://docs.medusajs.com/mcp` for answering Medusa-specific questions.
