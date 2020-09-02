# Blur

Twitch Chat Bot

![Elixir CI](https://github.com/rockerBOO/blur/workflows/Elixir%20CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/rockerBOO/blur/badge.svg)](https://coveralls.io/github/rockerBOO/blur)

**Note** This is under heavy changes. Things might break with each release as we solidify the API.

This library will be a core component that will interact with IRC and have a bunch of helper commands to interact with IRC, WS and OBS connections.

Process Structure:

```
- Blur.App
  - Blur.Supervisor
    - Blur.BotSupervisor
      - Blur.BotExample
				- Blur.Adapters.IRC
    - Blur.ResolverSupervisor
      - Blur.HelloExampleResolver
```

This allows many bots and many resolvers with proper dynamic supervision.

Bots handle their own adapters with `@adapter`. Currently only IRC is supported.

## Install

First, add Blur to your mix.exs dependencies:

```elixir
def deps do
  [{:blur, "~> 0.3.0-beta1"}]
end
```

Then, update your dependencies:

```sh-session
$ mix deps.get
```

You will need to authenticate with OAuth. This is set with the `TWITCH_CHAT_KEY` environmental variable. See [.env.example](.env.example) for all the variables.

```sh-script
# The key generated from https://twitchapps.com/tmi/.
export TWITCH_CHAT_KEY=oauth:
```

Then, you can start the Blur application.

```elixir
def application do
    [
      applications: [:blur],
    ]
end
```

## Usage

```elixir
Blur.start_bot(bot, opts)

Blur.stop_bot(bot)
```
