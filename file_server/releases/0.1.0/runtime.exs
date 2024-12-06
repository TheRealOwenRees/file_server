import Config

config :file_server,
  port: 4321,
  fileserver_auth_key: System.get_env("FILESERVER_AUTH_KEY")
