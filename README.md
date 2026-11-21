# CircleSongs

Online song repository for circle singing communities. Browse songs with lyrics, chords, translations, and embedded recordings from SoundCloud, YouTube, Spotify, and Bandcamp.

## Setup

```sh
# Prerequisites: Ruby and Node (see .tool-versions), Docker
bundle install
yarn install
bin/dev                  # starts postgres, prepares the db, runs rails + vite
```

### Parallel checkouts

`bin/dev` (and `bin/services`) give every checkout, including each git
worktree, its own Docker Postgres on a Docker-assigned host port, plus free
Rails and Vite ports. Settings land in the gitignored `.env.local`, which
`config/boot.rb` and `bin/dev` load, so `bundle exec rspec` in a checkout uses
that checkout's database. At most 3 stacks run at once.

The Compose project is `circlesongs-<directory name>` in a worktree. The main
checkout keeps the plain `circlesongs` project and its existing
`circle-songs-postgres` volume.

When removing a worktree, delete its stack first:

```sh
bin/services down        # in the worktree: docker compose -p <project> down -v
git worktree remove <path>
```

In the main checkout `bin/services down` stops the stack but keeps the data.

## Development

```sh
bundle exec rspec        # run tests
bundle exec rubocop      # lint
bin/dev                  # start dev server
```

## Stack

Ruby on Rails 8.0, PostgreSQL, Vite, Stimulus, Bootstrap 5, Haml, ActiveAdmin, Devise, Shrine.
