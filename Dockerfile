# Latest version of Erlang-based Elixir installation: https://hub.docker.com/_/elixir/
FROM elixir:alpine

# Install NodeJS 6.x and the NPM
RUN apk add --update nodejs nodejs-npm inotify-tools

# Install yarn
RUN npm install -g yarn

# Configure required environment
ARG MIX_ENV
ENV MIX_ENV ${MIX_ENV:-dev}

# Set and expose PORT environmental variable
ARG PORT
ENV PORT ${PORT:-4000}
EXPOSE $PORT

WORKDIR /opt/app
# Install hex (Elixir package manager)
RUN mix local.hex --force

# Install rebar (Erlang build tool)
RUN mix local.rebar --force

# Copy all dependencies files
COPY mix.* ./

# Install all dependencies
RUN mix deps.get

# Compile all dependencies
RUN mix deps.compile

# Copy all application files
COPY . .

# Compile the entire project
RUN mix compile

# Install frontend stuff
WORKDIR /opt/app/assets
RUN yarn install
WORKDIR /opt/app

# Run Ecto migrations and Phoenix server as an initial command
CMD mix do ecto.migrate, phx.server
