defmodule FileServer.File do
  @moduledoc """
  File utilities
  """

  defp detect_mime_type(<<0x52, 0x49, 0x46, 0x46, _::binary>>), do: "image/webp"
  defp detect_mime_type(<<0xFF, 0xD8, 0xFF, _::binary>>), do: "image/jpeg"
  defp detect_mime_type(<<0x89, 0x50, 0x4E, 0x47, _::binary>>), do: "image/png"
  defp detect_mime_type(<<0x47, 0x49, 0x46, 0x38, _::binary>>), do: "image/gif"
  defp detect_mime_type(<<0x42, 0x4D, _::binary>>), do: "image/bmp"
  defp detect_mime_type(<<0x49, 0x49, 0x2A, 0x00, _::binary>>), do: "image/tiff"
  defp detect_mime_type(<<0x25, 0x50, 0x44, 0x46, _::binary>>), do: "application/pdf"
  defp detect_mime_type(<<0x4D, 0x5A, _::binary>>), do: "application/exe"
  defp detect_mime_type(_), do: "unknown"

  defp mime_type_to_extension("image/webp"), do: "webp"
  defp mime_type_to_extension("image/jpeg"), do: "jpg"
  defp mime_type_to_extension("image/png"), do: "png"
  defp mime_type_to_extension("image/gif"), do: "gif"
  defp mime_type_to_extension("image/bmp"), do: "bmp"
  defp mime_type_to_extension("image/tiff"), do: "tiff"
  defp mime_type_to_extension("application/pdf"), do: "pdf"
  defp mime_type_to_extension("application/exe"), do: "exe"
  defp mime_type_to_extension("unknown"), do: "bin"

  defp file_name_as_timestamp(data, path) do
    timestamp = FileServer.Date.timestamp()
    mime_type = detect_mime_type(data)
    file_extension = mime_type_to_extension(mime_type)
    file_name = "#{timestamp}.#{file_extension}"
    Path.join(path, file_name)
  end

  @spec save_file(binary(), Path.t()) :: {:ok, Path.t()} | {:error, atom}
  def save_file(data, path) do
    filename = file_name_as_timestamp(data, path)
    File.mkdir_p!(path)
    response = File.write(filename, data)

    case response do
      :ok -> {:ok, Path.basename(filename)}
      _ -> response
    end
  end

  @spec delete_file(Path.t()) :: :ok | {:error, atom()}
  def delete_file(path), do: File.rm(path)

  @spec file_exists?(Path.t()) :: boolean()
  def file_exists?(path) do
    case File.stat(path) do
      {:ok, _} -> true
      _ -> false
    end
  end
end
