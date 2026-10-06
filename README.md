# CircleSongs

Online song repository for circle singing communities. Browse songs with lyrics, chords, translations, and embedded recordings from SoundCloud, YouTube, Spotify, and Bandcamp.

## Setup

```sh
# Prerequisites: Ruby 3.4.11, Node 22.13.1, PostgreSQL
cp .envrc.sample .envrc  # configure environment variables
docker compose up -d     # start postgres
bundle install
yarn install
bin/rails db:setup
bin/dev                  # starts rails + vite dev servers
```

## Development

```sh
bundle exec rspec        # run tests
bundle exec rubocop      # lint
bin/dev                  # start dev server
```

## Stack

Ruby on Rails 8.0, PostgreSQL, Vite, Stimulus, Bootstrap 5, Haml, ActiveAdmin, Devise, Shrine.
