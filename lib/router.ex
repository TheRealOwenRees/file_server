defmodule FileServer.Router do
  use Plug.Router

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
    [url] = Plug.Conn.get_req_header(conn, "url")

    response =
      url
      |> FileServer.PlantId.get_image()

    case response do
      {:ok, filename} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(201, Jason.encode!(%{filename: filename}))

      _ ->
        conn |> send_resp(404, "Image not found")
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
