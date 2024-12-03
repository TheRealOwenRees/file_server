defmodule FileServer.PlantId do
  @moduledoc """
  Image writing and conversion utilities, for PlantId Discord Bot
  """

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
      "image/jpeg" -> data |> FileServer.File.save_file(@upload_directory)
      "image/webp" -> convert_image_to_jpg(data) |> FileServer.File.save_file(@upload_directory)
      "image/png" -> convert_image_to_jpg(data) |> FileServer.File.save_file(@upload_directory)
      "image/gif" -> convert_image_to_jpg(data) |> FileServer.File.save_file(@upload_directory)
      "image/bmp" -> convert_image_to_jpg(data) |> FileServer.File.save_file(@upload_directory)
      "image/tiff" -> convert_image_to_jpg(data) |> FileServer.File.save_file(@upload_directory)
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

  @doc """
  Checks if an image exists in the upload directory
  """
  @spec image_exists?(String.t()) :: boolean()
  def image_exists?(filename) do
    file_path =
      Path.join(@upload_directory, filename)

    FileServer.File.file_exists?(file_path)
  end

  @spec convert_image_to_jpg(binary()) :: binary() | {:error, String.t()}
  defp convert_image_to_jpg(binary) do
    case Image.from_binary(binary) do
      {:ok, image} ->
        case Image.write(image, :memory, suffix: ".jpg") do
          {:ok, jpg_binary} ->
            jpg_binary

          {:error, _} ->
            {:error, "Could not convert image"}
        end

      {:error, _} ->
        {:error, "Could not convert image"}
    end
  end
end
