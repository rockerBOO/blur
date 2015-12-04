defmodule Blur.Lastfm do
  @moduledoc """
    Interface with last.fm

    get_last_played()

  """

  require Logger

  def get_last_played() do
    user = System.get_env("LAST_FM_USER")

    method = "method=user.getRecentTracks&user=#{user}&nowplaying=true"
    latest_track = Lastfm.Request.get!(method).body
    |> Map.fetch!("recenttracks")
    |> Map.fetch!("track")
    |> hd

    artist = latest_track["artist"]["#text"]
    title  = latest_track["name"]
    album  = latest_track["album"]["#text"]

    Logger.debug "#{artist} - #{album} - #{title}"

    {artist, album, title}
  end
end
