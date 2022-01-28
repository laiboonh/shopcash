# ./Dockerfile

# Extend from the official Elixir image.
FROM hexpm/elixir:1.13.0-rc.1-erlang-23.3.4.11-ubuntu-impish-20211102

# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Hex package manager.
# By using `--force`, we don’t need to type “Y” to confirm the installation.
RUN mix local.hex --force

RUN mix local.rebar --force

CMD [ "./start.sh" ]