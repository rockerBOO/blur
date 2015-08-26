Blur
====

Chat Bot for Streamers. Built to scale. Fast, efficient processing.

## Install

To setup, the configuration options are in `.env`. `.env.example` is setup to show how to configure, and just rename to `.env`.

```elixir
# The key generated from twitchtmi.com/chat
export TWITCH_CHAT_KEY=oauth:

# Username on Twitch for the Bot.
# It needs to match to the user of the access token/chat key.
export TWITCH_USERNAME=

# OPTIONAL. This takes precidence over the chat key for more intergrated options (authenticated calls to twitch)
# export TWITCH_ACCESS_TOKEN=
```

## To Run

`source .env && iex -S mix`

## Configuration for Channels

Configuration for channels are stored in `data/CHANNEL/`

* `data/rockerboo/commands.json`
	* Commands list
* `data/rockerboo/config.json`
	* Configuration options for the channel
* `data/rockerboo/aliases.json`
	* Stores aliases for commmands
