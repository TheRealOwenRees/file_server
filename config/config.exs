# import Config

# if config_env() in [:dev, :test] do
#   for path <- [".env.exs", ".env.#{config_env()}.exs"] do
#     path = Path.join(__DIR__, "..") |> Path.join("config") |> Path.join(path) |> Path.expand()
#     if File.exists?(path), do: import_config(path)
#   end
# end

# config :file_server,
#   port: 4321,
#   fileserver_auth_key: nil
