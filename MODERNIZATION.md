# Modernization status

Tracking doc for the ongoing refactor of this app: modern toolchain, LiveView
frontend, a cleaner data layer, and a durable scraper. Update this file as
work lands so the effort can be picked up in a later session without
re-deriving context.

## Done

**Tooling & dependencies** — `mise.toml` pins Elixir/Erlang/Ruby. `mix.exs`
bumped to Phoenix 1.8, LiveView 1.2, Ecto 3.14, Bandit (replacing cowboy),
esbuild/tailwind (no Node). All known-vulnerable/dead deps removed (`poison`,
`react_phoenix`, the JS lockfile entirely). Config modernized (`Mix.Config` →
`Config`, `config/runtime.exs` for prod secrets, PubSub 2.x).

**Data layer** — Synergies normalized out of the old embedded
`{:array, {:map}}` column into real tables: `synergies` (deduped by wiki
`link`, which is a true 1:1 key — verified against the scraped data) plus
`gun_synergies`/`item_synergies` join tables carrying the per-participant
`effect` text. New `GungeonSearch.Catalog` context is now the single entry
point (`search/1`, `get_gun!/1`, `get_item!/1`, `synergies_for/1`) —
`search/1` does a trigram-ranked (`pg_trgm`) `UNION ALL` across guns/items in
one query instead of an unindexed `ILIKE` scan. `mix gungeon.seed` replaces
the old hardcoded-path seeder, upserts idempotently from
`priv/repo/data/*.json`.

**Frontend** — React/webpack deleted entirely. Phoenix LiveView instead:
`HomeLive` (search-as-you-type), `GunLive.Show`, `ItemLive.Show` (item page
didn't exist before — dead route, always 500'd). Tailwind v4 (CSS-first
config, no `tailwind.config.js`). JSON `/api/search/:query` kept for
external consumers, simplified to plain `json(conn, ...)`.

**Tests** — `CatalogTest`, LiveView tests for all 3 pages,
`SearchControllerTest`, `CatalogFixtures` helper. `mix test` and
`mix compile --warnings-as-errors` both clean.

## Remaining

### 1. Ruby scraper rewrite

Current state: `gun_item_scraper.rb` and `synergy_scraper.rb` still point at
the dead `enterthegungeon.gamepedia.com`, have no `Gemfile`/version pin,
parse wiki table rows by **positional column index** (breaks silently if the
wiki adds/reorders a column), and only ever scraped item synergies (guns
never got synergy-scraped, despite `guns-synergies.json` existing in
`priv/repo/data/` — check how that file was actually produced before
assuming the current scraper covers it).

Plan:
- `Gemfile` pinned via the `mise`-installed Ruby: `nokogiri`, `faraday` +
  `faraday-retry` (replace raw `open-uri`), `thor` (CLI), `rspec` +
  `vcr`/`webmock` (tests).
- Restructure into `scraper/` with small classes instead of procedural
  scripts: `Scraper::Client` (HTTP + retry/backoff + a polite delay between
  requests — the old scripts hammer the wiki with none), `Scraper::GunParser`
  / `Scraper::ItemParser` (parse by **column header name**, not index),
  `Scraper::SynergyParser` (apply to both guns and items).
- `Scraper::CLI` (Thor): `bin/scraper guns|items|synergies|all`, writing into
  `priv/repo/data/*.json` (already the shape `mix gungeon.seed` expects).
- Point at `https://enterthegungeon.fandom.com/wiki/...` — **the actual
  table/CSS structure needs live verification**, fandom's skin likely
  differs from the old gamepedia one. Don't assume a URL swap is enough.
- RSpec + VCR cassettes so tests don't hit the live wiki; one smoke task
  that does.
- Update `mise.toml`'s `scrape` task and this repo's `README.md` once
  `bin/scraper` actually exists (both already reference it forward-looking).

### 2. Deploy — Docker + Mix release

- `config/runtime.exs` already exists with the DB/secret/host env-var
  pattern — extend as needed, don't restart from scratch.
- Multi-stage `Dockerfile`: build stage on the same Elixir/OTP versions
  pinned in `mise.toml`, `mix release`, slim runtime stage.
  `docker-compose.yml` for local Postgres + app parity.
- `.dockerignore`, health-check endpoint.

### 3. CI + remaining test coverage

- GitHub Actions: `mix deps.get`, `mix test`, `mix format --check-formatted`,
  `mix credo` (already a dep), `bundle exec rspec`, `bundle exec rubocop`
  (once the scraper rewrite lands).
- Current Elixir-side test coverage is a solid baseline (Catalog + all 3
  LiveViews + JSON API) but not exhaustive — revisit once the scraper and
  deploy pieces are in.

## Notes for whoever picks this up

- DB dev credentials are `postgres`/`postgres` (`config/dev.exs`) — on a
  fresh machine this needs `sudo -u postgres psql -c "ALTER USER postgres
  WITH PASSWORD 'postgres';"` (or point `dev.exs` at Docker Compose Postgres
  once that lands in step 2 above).
- Building Erlang from source (what `mise install` does) needs
  `build-essential libssl-dev libncurses-dev pkg-config autoconf` — without
  `libssl-dev` specifically, Erlang builds but silently drops `:crypto`/`:ssl`,
  which breaks Mix itself, not just this app.
- `mix ecto.setup` runs create + migrate + `gungeon.seed` in one shot.
