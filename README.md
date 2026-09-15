# GungeonSearch

A simple and quick fuzzy search tool for Enter the Gungeon guns, items, and
their synergies. Data is scraped from the
[Enter the Gungeon wiki](https://enterthegungeon.fandom.com/) with a Ruby
scraper. Phoenix + LiveView server-rendered frontend, no separate JS
frontend build.

## Current Progress

- [x] Phoenix server
- [x] Guns, items, and synergies normalized into the DB
- [x] Fuzzy (trigram-ranked) search
- [x] LiveView search homepage
- [x] LiveView gun/item detail pages

## Running the App

Tool versions (Elixir/Erlang/Ruby) are pinned via [mise](https://mise.jdx.dev/).

  * Install pinned tools: `mise install`
  * Install deps: `mix deps.get`
  * Install/build JS+CSS assets: `mix assets.setup && mix assets.build`
  * Create, migrate, and seed the database: `mix ecto.setup`
  * Start the Phoenix endpoint: `mix phx.server`

Now visit [`localhost:4000`](http://localhost:4000).

Postgres itself isn't mise-managed - use your OS package (with a `postgres`/`postgres`
dev role, matching `config/dev.exs`) or run one via Docker.

### Loading fresh data from the wiki

The seed data under `priv/repo/data/*.json` was produced by the Ruby
scraper (`bin/scraper`, see its own docs). To re-scrape and reload:

```
bundle install
bundle exec bin/scraper all
mix gungeon.seed
```

`mix gungeon.seed` is safe to re-run - guns/items/synergies are upserted,
not blindly inserted.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * LiveView docs: https://hexdocs.pm/phoenix_live_view
