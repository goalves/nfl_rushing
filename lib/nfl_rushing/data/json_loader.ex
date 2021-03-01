defmodule NflRushing.Data.JSONLoader do
  @moduledoc """
  Load content from a JSON file.
  """

  alias NflRushing.Data.Loader

  @behaviour Loader

  require Logger

  @impl Loader
  # sobelow_skip ["Traversal"]
  def load(source) when is_binary(source) do
    expanded_path = Path.expand(source)
    Logger.info("Loading file data from #{expanded_path}")

    with {:ok, binary_content} <- File.read(expanded_path),
         {:ok, json_data} <- Jason.decode(binary_content) do
      Logger.debug("Successfully loaded file on #{expanded_path}")
      {:ok, json_data}
    end
  end
end
