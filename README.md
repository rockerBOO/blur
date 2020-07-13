Blur
====

Twitch Chat Bot

![Elixir CI](https://github.com/rockerBOO/blur/workflows/Elixir%20CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/rockerBOO/blur/badge.svg)](https://coveralls.io/github/rockerBOO/blur)

## Install

First, add Blur to your mix.exs dependencies:

```elixir
def deps do
  [{:blur, "~> 0.2"}]
end
```

Then, update your dependencies:

```sh-session
$ mix deps.get
```

To setup, the configuration options are in `.env`. `.env.example` is setup to show how to configure, and just rename to `.env`.

```elixir
# The key generated from https://twitchapps.com/tmi/.
export TWITCH_CHAT_KEY=oauth:

# Username on Twitch for the Bot.
# It needs to match to the user of the access token/chat key.
export TWITCH_USERNAME=
```


