# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is "App Pedreiros" - a worker-first job marketplace platform for the Brazilian construction industry. The application implements a revolutionary "worker-selects" paradigm that inverts traditional freelance platforms by eliminating bidding wars. Instead of workers competing with proposals, clients post jobs with fixed prices and workers can claim them on a first-come, first-served basis.

## Development Commands

### Starting the Application
```bash
# Start the development server with CSS watching
bin/dev

# Or start components individually:
bin/rails server          # Web server
bin/rails tailwindcss:watch  # CSS compilation
```

### Database Operations
```bash
bin/rails db:create        # Create databases
bin/rails db:migrate       # Run migrations
bin/rails db:reset         # Drop, create, migrate and seed
bin/rails db:rollback      # Rollback last migration
```

### Testing
```bash
bin/rails test             # Run all tests except system tests
bin/rails test:db          # Reset database and run tests
bin/rails test:system      # Run system tests

# Run specific test files or methods
bin/rails test test/models/job_test.rb
bin/rails test test/models/job_test.rb:test_name
```

### Code Quality
```bash
# Security analysis
bundle exec brakeman

# Code auditing
bundle exec bundle-audit

# Ruby style (Omakase)
bundle exec rubocop
```

## Architecture Overview

### Core Domain Models
- **User**: Polymorphic model supporting both `client` and `worker` roles via enum
  - Clients create and post jobs
  - Workers claim and work on jobs
  - Uses `has_secure_password` for authentication
- **Job**: Central entity representing work opportunities with statuses: `open`, `in_progress`, `completed`
  - Atomic claiming mechanism prevents race conditions
  - Fixed pricing model (no bidding)
  - Validation includes reasonable price limits (max R$ 100,000)
- **Chat**: Communication channel automatically created when a job is claimed
- **Message**: Individual chat messages within job conversations

### Application Structure
- **Components**: Uses Phlex for component-based views in `app/components/`
- **Reflexes**: StimulusReflex classes in `app/reflexes/` handle real-time interactions
- **Views**: Mixed approach with Phlex components and traditional Rails views
- **Assets**: Tailwind CSS with Rails asset pipeline via Propshaft

### Key Business Logic
- **Claim System**: Workers can claim open jobs, which immediately changes status to prevent race conditions
- **Role-based Access**: Controllers enforce role restrictions (clients create jobs, workers claim them)
- **Real-time Updates**: StimulusReflex enables live updates for job status and chat messages

### Technology Stack Patterns
- **Hotwire-first**: Uses Turbo and Stimulus for SPA-like interactions without JavaScript frameworks
- **Phlex Views**: Component-based view rendering instead of ERB templates
- **StimulusReflex**: Real-time reactivity with server-rendered components
- **Solid Queue**: Background job processing for async operations like notifications

## Key Development Areas

### Critical Business Logic
The most important code paths involve:
1. **Job claiming mechanism** (`JobsController#show` + reflexes) - must be atomic to prevent double-claims
2. **Role-based access control** - clients vs workers have different permissions
3. **Real-time chat system** - uses ActionCable + StimulusReflex for instant messaging

### Planned Integrations (from planning docs)
- **Brazilian fiscal compliance**: NFS-e integration via PlugNotas or FocusNFe APIs
- **CNPJ verification**: BrasilAPI integration for business validation
- **Payment processing**: Pix integration with escrow functionality
- **Geolocation**: For job proximity and check-in/check-out features

### Database Design Philosophy
- Simple, normalized schema focusing on the core job lifecycle
- Uses Rails conventions (foreign keys, indexes, timestamps)
- Designed for Brazilian market specifics (CPF/CNPJ validation, Pix payments)

## Testing Strategy

- Uses Rails default minitest framework
- System tests with Capybara/Selenium for end-to-end workflows  
- Focus testing on the critical "claim" workflow to prevent race conditions
- Test role-based access controls thoroughly

## Deployment

- **Container-ready**: Dockerfile optimized for production deployment
- **Kamal deployment**: Ready for deployment to any Docker-compatible host
- **Thruster**: HTTP acceleration and asset serving
- **Solid adapters**: Uses SQLite-backed cache and queue for simplified ops

## Environment Setup

### Ruby Version
- Ruby 3.4.7 (see `.ruby-version`)
- Node.js LTS (managed via mise)

### Development Server
- Default port: 3001 (configured in `Procfile.dev`)
- Uses `bin/dev` to start both web server and CSS watcher concurrently

### Important Files
- `app/reflexes/job_reflex.rb`: Critical job claiming logic with race condition prevention
- `app/models/job.rb`: Contains price validation and business rules
- `app/models/user.rb`: Role-based user model with Brazilian Portuguese validation messages

## Development Philosophy

This codebase follows Rails conventions and "The Rails Way" with modern enhancements:
- Convention over configuration
- Hotwire over JavaScript frameworks  
- Server-side rendering with real-time updates
- Simple, maintainable code over complex architectures
- Brazilian market focus (Portuguese validation messages, CPF/CNPJ considerations)

The business model prioritizes worker empowerment over platform profit maximization, which influences technical decisions toward transparency and fairness in the codebase.
