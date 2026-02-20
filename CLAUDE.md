# CuekooAPI - Claude Code Guide

## Project Overview

**CuekooAPI** is a Phoenix/Elixir JSON REST API backend. It handles user accounts, authentication, and reminders (scheduling/location-based events).

- **Framework**: Phoenix 1.7 (JSON-only, no LiveView/HTML in production routes)
- **HTTP Server**: Bandit
- **Database**: PostgreSQL via Ecto
- **Auth**: Guardian (JWT) + HttpOnly cookie transport
- **Password hashing**: Argon2
- **Email**: Swoosh (local adapter in dev)

---

## Common Commands

```bash
# Install deps and set up DB
mix setup

# Start dev server
mix phx.server

# Run tests (creates + migrates DB automatically)
mix test

# DB management
mix ecto.migrate
mix ecto.reset        # drop + recreate + migrate + seed
```

---

## Architecture

### Directory Layout

```
lib/
  cuekoo_api/            # Business logic (contexts)
    auth/
      auth_manager.ex    # Password verification / user authentication
      guardian.ex        # Guardian callbacks (subject_for_token, resource_from_claims)
      pipeline.ex        # Guardian plug pipeline (VerifySession, VerifyHeader, LoadResource)
      error_handler.ex   # Auth error responses
    users/
      user.ex            # User schema + changeset (Argon2 hashing in changeset)
    users.ex             # Users context (CRUD)
    reminders/
      reminder.ex        # Reminder schema + changeset
    reminders.ex         # Reminders context (CRUD)
    repo.ex
    mailer.ex
  cuekoo_api_web/        # Web layer (controllers, plugs, router)
    plugs/
      auth_cookie.ex     # Reads auth_token cookie → puts token where Guardian expects it
    controllers/
      session_controller.ex   # login / logout / check session
      user_controller.ex
      reminders_controller.ex
    router.ex
    endpoint.ex
```

### Auth Flow

1. `AuthCookie` plug reads the `auth_token` cookie and calls `Guardian.Plug.put_current_token/2`.
2. `CuekooApi.Auth.Pipleine` (note: typo in module name) runs `VerifySession`, `VerifyHeader`, then `LoadResource` (allows blank — unauthenticated requests pass through).
3. Protected routes use `Guardian.Plug.EnsureAuthenticated` in the `:ensure_auth` pipeline.
4. On login, a JWT is minted and written as an HttpOnly cookie.

### Router Structure

```
/api  (pipe_through: [:api, :auth])
  GET  /               HomeController
  /users
    POST  /new         UserController.create   (public)
    GET   /:id         UserController.show     (public)
    PUT   /:id         UserController.update   (public)
  /reminders           (pipe_through: [:ensure_auth])
    GET   /            RemindersController.index
    POST  /new         RemindersController.new
    PUT   /update      RemindersController.update
  /auth
    GET   /login       SessionController.new   (check current session)
    POST  /login       SessionController.login
    POST  /logout      SessionController.logout
```

---

## Key Schemas

### User (`users` table)
Fields: `name`, `email`, `address`, `password` (virtual), `hashed_password`, `confirmed_at`
- Password: 8–16 chars, requires uppercase, lowercase, digit, special char
- Hashed with Argon2 inside the changeset (`maybe_hash_password/1`)

### Reminder (`reminders` table)
Fields: `name`, `location` (map/JSON), `notes`, `event_scheduled_at`, `remind_frequency`, `is_active`, `user_id`

---

## Configuration

- **Guardian secret**: `GUARDIAN_SECRET_KEY` env var (required in prod)
- **Auth cookie** (configured in `config/config.exs`):
  - Name: `auth_token`
  - `http_only: true`, `secure: true`, `same_site: "Strict"`, `max_age: 7 days`
  - Override per environment in `config/dev.exs`, `config/prod.exs`, etc.

---

## Known Issues / TODOs

- `CuekooApi.Auth.Pipleine` — typo in module name (should be `Pipeline`). Referenced in router as `CuekooApi.Auth.Pipleine`.
- `AuthManager.authenticate_user` uses `Argon2.no_user_verify()` on missing users (timing attack mitigation). Monitor CPU/memory impact in production.
- `IO.inspect` left in `SessionController.new` (dev debug artifact).
- `Reminders` context `list_reminders/0` returns all reminders globally — no user scoping yet.
