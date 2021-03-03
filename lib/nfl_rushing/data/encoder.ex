defmodule NflRushing.Data.Encoder do
  @doc """
  Encodes data into a map.
  """

  @callback encode(any()) :: map()
end
