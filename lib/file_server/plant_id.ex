defmodule FileServer.PlantId do
  @upload_directory "./priv/static/plant_id"

  def get_image(url) do
    HTTPoison.start()
    response = HTTPoison.get!(url)

    case response.status_code do
      200 -> save_image(response.body)
      _ -> {:error, response.status_code}
    end
  end

  def save_image(data) do
    case FileServer.File.detect_mime_type(data) do
      "image/webp" -> FileServer.File.save_file(data, @upload_directory)
      "image/jpeg" -> FileServer.File.save_file(data, @upload_directory)
      "image/png" -> FileServer.File.save_file(data, @upload_directory)
      "image/gif" -> FileServer.File.save_file(data, @upload_directory)
      "image/bmp" -> FileServer.File.save_file(data, @upload_directory)
      "image/tiff" -> FileServer.File.save_file(data, @upload_directory)
      _ -> {:error, "Unsupported file type"}
    end
  end

  def load_image(filename) do
    Path.join(@upload_directory, filename)
    |> FileServer.File.get_file()
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
