defmodule FileServer.Router do
  use Plug.Router

  @authorization_key Application.compile_env(:file_server, :fileserver_auth_key)

  plug(:match)
  plug(:dispatch)

  def init(options) do
    options
  end

  get "/health" do
    conn
    |> send_resp(200, "Server is running")
  end

  post "/plant_id" do
    url = Plug.Conn.get_req_header(conn, "url") |> List.first()
    authorization = Plug.Conn.get_req_header(conn, "authorization") |> List.first()

    if is_nil(url) or is_nil(authorization) do
      conn
      |> send_resp(400, "Bad Request: Missing required headers")
    end

    if authorization != @authorization_key do
      conn
      |> send_resp(401, "Unauthorized")
    end

    response =
      url
      |> FileServer.PlantId.get_image()

    case response do
      {:ok, filename} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(201, Jason.encode!(%{filename: filename}))

      {:error, message} ->
        conn
        |> send_resp(500, message)
    end
  end

  delete "/plant_id/:file" do
    response =
      conn.params["file"]
      |> FileServer.PlantId.delete_image()

    case response do
      :ok -> conn |> send_resp(200, "File deleted")
      _ -> conn |> send_resp(500, "An error has occured")
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
