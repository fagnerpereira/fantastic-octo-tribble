# Construction Workers App - Official Project Wiki

This wiki centralizes all knowledge, research, strategy, and technical planning for the project.

---

# 1. Strategy: The "Worker-Selects" Paradigm

> **Summary:** Inverting the auction logic (Upwork/GetNinjas) to a "first-come, first-served" model, similar to claiming an issue on Git.

### The Problem of "Platformization"

The current model imposes predatory competition and job "auctions," generating fatigue and low compensation.

### The Solution: Worker-Selects

- **Inverted Flow:** Client posts a defined task ("Issue"). Qualified worker claims it.
- **No Auction:** Fixed or defined price, no bidding wars.
- **Agency:** The worker chooses what they want to do.

### Governance and Trust

- **WIP Limit:** Workers have a limit on simultaneous tasks to avoid accumulation.
- **Entry Curation:** Ensure that those who have access to the "Claim" button are qualified.
- **Auditable Communication:** All chat is logged for dispute resolution.

---

# 2. Market Research (Brazil)

### Context

- **Informality:** 67-76% in construction.
- **Tech:** High penetration of WhatsApp and Pix.
- **Pain Points:** "Curious clients" (fake leads), lack of security, uncertain payment.

### Competitors

- **GetNinjas:** Pay-per-lead model (hated by professionals). Disclaims responsibility.
- **Triider:** Charges 25%, but has serious operational problems.
- **Habitissimo:** Left Brazil in Oct/2024.
- **Urban Company (India):** The model to follow. Full-stack, training, standardization.

### Opportunities

- **Formalization:** Help with MEI (Microentrepreneur) and income history.
- **Security:** Escrow (Pix), Witnesses, Auditable Logs.
- **Guilds:** Referrals between professionals.

---

# 3. Technical Specification and Architecture

### Main Stack

- **Backend:** Ruby on Rails 8 (API-first + Hotwire).
- **Frontend:** Hotwire (Turbo/Stimulus) + TailwindCSS.
- **DB:** SQLite (for MVP), PostgreSQL (production).
- **Chat:** ActionCable (internal) or Sendbird (external/auditable).
- **Payments:** Pix (Mercado Pago/PagSeguro).
- **NFS-e:** FocusNFe or PlugNotas (via Sidekiq).
- **CNPJ:** BrasilAPI.

### Core Data Modeling

- `User` (Worker/Client/Admin)
- `Job` (Status: Open, Claimed, Completed)
- `Claim` (Act of claiming the task)
- `Contract` (Generated after Claim)
- `AuditLog` (Immutable action log)

---

# 4. MVP Planning and Roadmap

### Epic 1: Foundation (Weeks 1-2)

- Rails setup, Auth (Devise), Profiles (Worker/Client).
- [x] `rails new`, Testing, Tailwind.

### Epic 2: Core (Weeks 3-4)

- Post Job, Job Board, **Claim System**.
- [ ] `Job` Model, Photo upload, Geolocation.

### Epic 3: Execution (Weeks 5-6)

- Chat, Updates (Before/After photos), Completion.
- [ ] ActionCable, `JobUpdate`.

### Epic 4: Payments (Weeks 7-8)

- Payment flow, Reviews.
- [ ] Financial dashboard.

### Epic 5: Protection (Weeks 9-10)

- Referrals, Witnesses, Logs.
- [ ] Generate job PDF.

### Epic 6: Launch

- Deploy, Monitoring, Analytics.

---

# Key Features Overview

## The "Worker-Selects" Model

Instead of workers competing by sending proposals (like Upwork), this platform inverts the power dynamic:

1. **Client Posts:** Defines scope, location, and fixed price
2. **Platform Validates:** Ensures task is clear
3. **Worker Claims:** Professional reviews available jobs and clicks "Claim" - contract is instantly closed

## Governance Mechanisms

- **WIP Limit:** Each worker can only have X active jobs simultaneously
- **Client Validation:** Verified payment methods, job posting quality
- **Auditable Communication:** All chat happens in-platform for dispute resolution

## Brazilian Market Specifics

### Pain Points Addressed

| Market Pain                | Proposed Solution                                                                    |
| :------------------------- | :----------------------------------------------------------------------------------- |
| Fake Leads/Curious Clients | "Claim" model: Client already defined price and scope                                |
| Non-payment                | Pix payment with escrow or logged direct payment                                     |
| Lack of History            | "Digital Notebook": App serves as proof of income and auditable professional history |
| Safety                     | Witness system and Check-in/Check-out with geolocation                               |

### Empowerment Features (Post-MVP)

- **MEI Helper:** Step-by-step guide for formalizing as MEI (Microentrepreneur)
- **Receipt Generator:** Professional service receipt generation in PDF
- **Financial Kit:** Simple material cost tracking per service, automatic profit calculation
- **Discount Hub:** Partnerships with construction supply stores

---

# Technical Implementation Details

## API-First Architecture

```ruby
rails new my_app --api
```

Benefits:

- Lighter middleware stack
- Clean separation between backend logic and frontend clients
- Ready for mobile apps
- Still benefits from Rails' routing, caching, authentication

## Essential Services

- **Background Jobs:** Sidekiq for all external API calls (NFS-e, notifications)
- **Authentication:** Devise + Devise-JWT for token-based auth
- **Serialization:** fast_jsonapi or ActiveModel::Serializers

## Core Data Models

| Model    | Key Fields                               | Relationships                         | Description                          |
| -------- | ---------------------------------------- | ------------------------------------- | ------------------------------------ |
| User     | email, password_digest, role             | has_one :profile, has_many :jobs      | Central auth and user identification |
| Profile  | full_name, cnpj_cpf, bio, skills, rating | belongs_to :user                      | Public and private user information  |
| Job      | title, description, price, status        | belongs_to :client, has_one :claim    | The "issue" posted by client         |
| Claim    | job_id, worker_id, claimed_at            | belongs_to :job, belongs_to :worker   | Formalizes job claim by worker       |
| Contract | claim_id, start_time, payment_status     | belongs_to :claim, has_many :messages | Formal agreement after claim         |

## Critical Workflows

### Job Posting Flow

1. Client fills structured form (title, description, tags, fixed price)
2. Platform validates completeness
3. Job appears on board with status: `open`

### Claim Flow (Most Critical)

1. Worker clicks "Claim"
2. **System checks WIP limit** for that worker
3. **Database transaction:**
   - Create Claim record (job_id + worker_id)
   - Update Job status to `claimed`
   - Generate Contract
4. **Async:** Provision chat channel
5. Return success/failure

### Chat Integration

- Use external API (Sendbird recommended for audit API)
- Store only metadata (`external_channel_id`)
- Admin endpoint to retrieve full history for disputes

### Brazilian Fiscal Integration

#### NFS-e (Service Invoice)

- Use aggregator API: PlugNotas or FocusNFe
- Async processing via Sidekiq
- Webhook handling for status updates
- Store XML/PDF securely

#### CNPJ Verification

- BrasilAPI for MVP (free, open-source)
- Auto-fill registration forms
- Validate MEI status
- Future: Migrate to official Conecta Gov API

---

# Strategic Roadmap

## MVP Goals

**Validate the "worker-selects" hypothesis**

Core Features:

- User registration (Client/Worker roles)
- Basic profiles
- Job posting
- Job board with basic filters
- Claim action with WIP limit
- Real-time chat integration
- Basic contract/payment flow

Technical Choices:

- BrasilAPI for CNPJ
- Defer NFS-e integration
- Manual/simple payment handling

## Version 1.0 Goals

**Full operationalization for Brazilian market**

Added Features:

- Complete NFS-e integration with Sidekiq + webhooks
- Admin panel with chat history viewer
- Advanced job board filters and search
- Complete rating/review system
- Migrate to Conecta Gov API if needed

## Long-term Vision

**Become the "Operating System for Autonomous Professionals"**

Evolution:

- V2: Empowerment Suite (MEI helper, receipt generator, financial kit)
- V3: Material discount hub, community forum
- V4+: Embedded financial services (micro-insurance, retirement planning), advanced project management, market-based pricing recommendations

---

# Success Metrics

The platform's success depends on creating a positive feedback loop:

1. **Superior work model** → Attracts high-quality workers
2. **Reliable worker pool** → Attracts clients seeking speed/quality
3. **Quick successful completions** → More job postings
4. **More opportunities** → More worker satisfaction
5. **Governance mechanisms** (WIP limit, auditable chat) → Maintains fairness and trust

This flywheel differentiates the platform from exploitative competitors and creates sustainable growth.
