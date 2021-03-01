defmodule NflRushing.Data.Loader do
  @doc """
  Loads data from a source into a list.
  """

  @callback load(source :: String.t()) :: {:ok, map() | maybe_improper_list()} | {:error, any()}
end
