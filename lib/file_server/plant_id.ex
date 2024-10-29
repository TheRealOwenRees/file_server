defmodule FileServer.PlantId do
  @upload_directory "./priv/static/plant_id"

  def get_image(url) do
    HTTPoison.start()
    response = HTTPoison.get!(url)

    case response.status_code do
      200 -> FileServer.File.save_file(response.body, @upload_directory)
      _ -> {:error, response.status_code}
    end
  end

  def delete_image(filename) do
    Path.join(@upload_directory, filename)
    |> FileServer.File.delete_file()
  end

  def image_exists?(filename) do
    file_path =
      Path.join(@upload_directory, filename)

    FileServer.File.file_exists?(file_path)
  end
end
