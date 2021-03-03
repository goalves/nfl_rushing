![Continuous Integration](https://github.com/goalves/nfl_rushing/workflows/Continuous%20Integration/badge.svg?branch=main)

# NFL Rushing

This repository contains application of the NFL Rushing project.

This application is a simple example of how to render, sort, filter, export, import structured elements using Elixir/Phoenix and LiveView.

## Installation and running this solution

The application depends on multiple parts to work properly. Even though it is possible to boot up in different ways.

### Dependencies

Recommended dependencies are as follows:

- Elixir 1.11.3-otp-23
- Erlang 23.2.4
- Docker (for Postgres 13)

Elixir and Erlang dependencies can be installed through `asdf`:

```sh
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
asdf install
```

Docker installation steps can be found [here](https://docs.docker.com/get-docker/).

### Setting Up Local Environment

First of all, you need to fetch all dependencies for the application using `mix deps.get`.

We use Docker to set up the container containing the Postgres database, to start it you need to run:

```sh
docker-compose up -d
mix setup
```

Please notice that `setup` already insert seeds on the database and executing it multiple times will create duplicated elements.

Now you only need to run `mix phx.server` to start the application.

## Running Tests and Static Code Analysis

All of them are set to run on CI however you can run them locally using the following commands:

- [Coveralls](https://github.com/parroty/excoveralls): `mix coveralls` for test coverage;
- [Dialyxir](https://github.com/jeremyjh/dialyxir): `mix dialyzer` for static code analysis and spec validation;
- [Sobelow](https://github.com/nccgroup/sobelow): `mix sobelow --config` for static code analysis focused on security and a few performance aspects;
- [Credo](https://github.com/rrrene/credo): `mix credo --strict` for general static code analysis;
- Elixir default Formatter: `mix format --check-formatted` for ensuring codebase is formatted.
