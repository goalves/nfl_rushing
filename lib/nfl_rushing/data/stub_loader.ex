defmodule NflRushing.Data.StubLoader do
  require Logger
  alias NflRushing.Data.Loader

  @behaviour Loader

  def load(source) when is_binary(source) do
    Logger.debug("Stub loader was called to load file on #{source}")

    {:ok, []}
  end
end
