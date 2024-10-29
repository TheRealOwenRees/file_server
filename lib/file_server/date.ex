defmodule FileServer.Date do
  @moduledoc """
  Date utilities
  """

  @doc """
  Get current UTC datetime in milliseconds as a string
  """
  @spec timestamp() :: String.t()
  def timestamp do
    DateTime.utc_now()
    |> DateTime.to_unix(:millisecond)
    |> to_string
  end
end
