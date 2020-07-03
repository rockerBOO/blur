import Config

config :blur, :autojoin, []

config :logger,
  backends: [:console]

config :logger, :error_log,
  path: "error.log",
  level: :error

import_config "#{Mix.env()}.exs"
