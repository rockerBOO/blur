Blur
====

Twitch Chat Bot

![Elixir CI](https://github.com/rockerBOO/blur/workflows/Elixir%20CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/rockerBOO/blur/badge.svg)](https://coveralls.io/github/rockerBOO/blur)

**Note** This is under heavy changes. Things might break with each release as we solidify the API.

This library will be a core component that will interact with IRC and have a bunch of helper commands to interact with IRC, WS and OBS connections.

## Install

First, add Blur to your mix.exs dependencies:

```elixir
def deps do
  [{:blur, "~> 0.2.1-rc1"}]
end
```

Then, update your dependencies:

```sh-session
$ mix deps.get
```

Then, you'll want to start the Blur application. 

```elixir
# [user, channels]
Blur.App.start_link(["800807", ["#rockerboo"]])
```

You will need to authenticate with OAuth. This is set with the `TWITCH_CHAT_KEY` environmental variable. See [.env.example](.env.example) for all the variables. 


```elixir
# The key generated from https://twitchapps.com/tmi/.
export TWITCH_CHAT_KEY=oauth:
```

## Quick Start

```sh-session
iex -S mix

iex> Blur.App.start_link(["800807", ["#rockerboo"]])
{:ok, <pid>}
iex> Blur.say "#rockerboo", "yo"
:ok
```

## Usage

```elixir
Blur.say("#rockerboo", "yo")
```

See the [Blur](lib/blur.ex) module for the current list of options.
