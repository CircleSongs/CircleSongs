# CircleSongs

> **Note:** Keep this file up to date. When new patterns, models, conventions, or architectural decisions emerge during development, update the relevant sections here.

Online song repository for circle singing communities. Public-facing catalog of songs with recordings, lyrics, chords, and educational content. Admin interface via ActiveAdmin.

## Stack

- Ruby 3.4.8 / Rails 8.0
- PostgreSQL (UUID primary keys everywhere)
- Redis + Sidekiq (background jobs)
- RSpec (test framework)
- Vite + Stimulus + Bootstrap 5 / Bootswatch
- Devise (auth, admin-only) + ActiveAdmin (admin UI)
- Shrine (file uploads, image derivatives)
- Haml (views)
- SCSS with CSS custom properties (design tokens)

## Domain Model

- **Song** — the core model. Has title (unique), lyrics, chords (ChordPro format), description, translation, image (Shrine). FriendlyId slugs. `featured` boolean. Belongs to composer. HABTM categories, languages. Has many recordings, song_chord_forms, tags (themes via acts-as-taggable-on). Ransack search enabled.
- **Recording** — belongs to song. Supports SoundCloud, YouTube, Spotify, Bandcamp embeds via `external_media_url`. Has `source` detection and `formatted_external_media_url` for embedding. Ordered by position.
- **Composer** — has many songs (counter cache). Name, URL, description.
- **Category** — HABTM songs. Has `restricted` flag (password-protected categories like "Sacred").
- **Language** — HABTM songs.
- **ChordForm** — chord fingering diagrams. Linked to songs via SongChordForm (positioned join model).
- **User** — Devise auth. `admin` boolean for admin access.
- **Password** — name/value store for restricted category access.
- **Vocabulary** — text/translation pairs (Quechua vocabulary page).
- **Playlist** — ordered collection of recordings.

## Architecture

- **Public site**: Songs browsing/search, category filtering, playlists, static content pages (Quechua, Ikaros, learning resources, etc.).
- **Admin**: ActiveAdmin at `/admin` — full CRUD for all models. Devise auth scoped to admin users.
- **Restricted categories**: Password-gated via `RestrictedCategorySessionsController` (stored in session). The "Sacred" category requires a password.
- **Feature flags**: Flipper (ActiveRecord adapter), UI at `/admin/flipper`.
- **Background jobs**: Sidekiq, mounted at `/admin/sidekiq`.
- **Search**: Ransack on songs (by title, composer, language, etc.).
- **Pagination**: Kaminari with custom Haml partials.
- **Chords**: ChordPro format parsed via `chordpro` gem, rendered as HTML. Chord diagram rendering via `vexchords` JS library.
- **Forms**: `MailForm`-based contact form and broken link report form.
- **Services**: `Recordings::BrokenLinkDetector`, `Recordings::UrlChecker` for link health monitoring.

## Frontend

- **Vite** (`vite_rails`) bundles JS/CSS — entry points in `app/frontend/entrypoints/`
- **Stimulus** controllers in `app/frontend/js/controllers/` with HMR via `vite-plugin-stimulus-hmr`
- **SCSS** in `app/frontend/scss/` — layered architecture with `@layer` cascade:
  - `_tokens.scss` — CSS custom properties (colors, typography, layout)
  - `_base.scss` — element defaults
  - `_layout.scss` — structural layout
  - `_pages.scss` — page-specific styles
  - `_utilities.scss` — utility classes
- **Design tokens**: Named color palette (daybreak-linen, moonlight-mist, warm-stone, crystaline-gold, ember-bronze, forest-smoke-green, midnight-teal, celestial-night-blue, temple-charcoal, aged-copper). Typography: Cormorant (headings), Alegreya Sans / Alegreya Sans SC (body/h3).
- **jQuery** injected globally via Rollup plugin (legacy dependency for ActiveAdmin/jQuery UI)
- **Bootstrap 5** + Bootswatch theme
- **Font Awesome Free** for icons
- **tom-select** for enhanced select inputs

## Development Guidelines

- **Always write specs.** Prefer TDD — write the test first, watch it fail, then implement.
- **Run `bundle exec rubocop` before finishing work.**
- **Views use Haml**, not ERB.
- **All IDs are UUIDs** — never use integer IDs.

### Git Commits

- Sentence case, present tense imperative: "Add feature", "Fix bug", "Update styling"
- Headline <= 70 characters

### Service Objects

- Follow the pattern in `app/services/` — namespaced by domain (e.g., `Recordings::BrokenLinkDetector`)
- Single responsibility, standard `call` interface

## Commands

```sh
bin/dev                       # start dev server (foreman: rails + vite)
bin/rails server              # start rails only
bin/vite dev                  # start vite dev server only
bundle exec rspec             # run full test suite
bundle exec rspec spec/models # run model specs only
bundle exec rubocop           # lint
bin/rails db:migrate          # run migrations
bin/rails db:schema:load      # load schema (faster for fresh setup)
docker compose up -d          # start postgres + redis
```

## Test Conventions

- RSpec with fixtures (in `spec/fixtures/`)
- Spec directories: `models/`, `requests/`, `system/`, `forms/`, `helpers/`, `services/`
- Devise test helpers included
- Shoulda matchers for model validations
- Capybara + headless Chrome for system tests
- SimpleCov for coverage

## Deployment

- GitHub Actions CI: PostgreSQL 14 service, RSpec + Vite build
- Heroku deployment (triggered on main branch push after CI passes)
- `app.json` for Heroku config
