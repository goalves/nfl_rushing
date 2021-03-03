defmodule NflRushing.Data.Exporter do
  @moduledoc """
  Module responsible for exporting elements to a CSV binary.
  """

  require Logger

  @column_separator ","
  @line_separator "\n"

  @spec run(list()) :: binary()
  def run(elements, mapping_function \\ nil) when is_list(elements) do
    contents = build_contents(elements, mapping_function)
    header_line = build_headers(elements, mapping_function)

    "#{header_line}\n#{contents}"
  end

  defp build_headers([element | _], mapping_function) do
    element
    |> apply_mapping_function(mapping_function)
    |> Map.keys()
    |> Enum.map_join(@column_separator, &preprocess_value/1)
  end

  defp build_headers([], _), do: ""

  defp build_contents(elements, mapping_function) when is_list(elements) do
    elements
    |> Flow.from_enumerable()
    |> Flow.map(&build_csv_line(&1, mapping_function))
    |> Enum.to_list()
    |> Enum.join(@line_separator)
  end

  defp build_csv_line(element, mapping_function) when is_map(element) do
    element
    |> apply_mapping_function(mapping_function)
    |> Enum.map_join(@column_separator, fn {_key, value} -> preprocess_value(value) end)
  end

  defp apply_mapping_function(element, function) when is_function(function), do: function.(element)
  defp apply_mapping_function(element, _), do: element

  defp preprocess_value(value) when is_atom(value), do: value |> Atom.to_string() |> preprocess_value()

  defp preprocess_value(value) when is_binary(value),
    do: String.replace(value, @column_separator, "\\#{@column_separator}")

  defp preprocess_value(value), do: value
end
