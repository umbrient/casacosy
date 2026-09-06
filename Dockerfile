# syntax=docker/dockerfile:1
# Production image for the SaPortal (pagefu) Rails app.

ARG RUBY_VERSION=3.1.7
FROM ruby:${RUBY_VERSION}-slim-bookworm AS base

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

WORKDIR /app


# ---------- build stage ----------
FROM base AS build

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential git pkg-config libpq-dev libyaml-dev curl ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Ruby gems (cached unless Gemfile* changes)
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}/ruby/"*/cache "${BUNDLE_PATH}/ruby/"*/bundler/gems/*/.git

# Node modules (cached unless package.json / yarn.lock changes)
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Application code
COPY . .

# Build JS/CSS bundles and precompile assets.
# require_master_key is disabled, so a dummy secret is enough here.
RUN SECRET_KEY_BASE=dummy ./bin/rails assets:precompile && \
    rm -rf node_modules tmp/cache


# ---------- runtime stage ----------
FROM base AS runtime

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      libpq5 libyaml-0-2 postgresql-client tzdata curl && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

COPY --from=build --chown=rails:rails /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=rails:rails /app /app

USER rails:rails

ENV PORT=3000
EXPOSE 3000

ENTRYPOINT ["/app/bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
