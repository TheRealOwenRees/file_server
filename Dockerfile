ARG ELIXIR="1.16.2"
ARG ERLANG="26.0.2"
ARG DEBIAN_VERSION="buster-20240513-slim"

# Step 1: Build release
FROM hexpm/elixir:${ELIXIR}-erlang-${ERLANG}-debian-${DEBIAN_VERSION} AS build

WORKDIR /file_server

RUN MIX_ENV=prod

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config
COPY lib lib

RUN mix deps.get --only prod
RUN MIX_ENV=prod mix release

# Step 2: Create app image
FROM debian:${DEBIAN_VERSION}

WORKDIR /file_server

RUN apt-get update -y && apt-get install -y openssl locales

COPY \
    --from=build \
    --chown=nobody:root \
    /file_server/_build/prod/rel/file_server ./

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

EXPOSE 4321

CMD ["/file_server/bin/file_server", "start"]