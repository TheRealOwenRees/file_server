defmodule FileServer do
  use Plug.Builder

  plug(Plug.Logger)

  plug(Plug.Static,
    at: "/public",
    from: "/file_server/priv/static"
  )

  plug(FileServer.Router)
end
