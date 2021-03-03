defmodule NflRushing.Query.PlayerParams do
  alias NflRushing.Query.{FilteringParams, SortingParams}

  @valid_sorting_fields [
    :name,
    :total_rushing_yards,
    :longest_rush,
    :rushing_touchdowns
  ]

  @valid_filtering_fields [:name]

  def build(sort_order, sort_field, filtering_name) do
    with {:ok, sorting_params} <- build_sorting_params(sort_order, sort_field),
         {:ok, filtering_params} <- build_filtering_params(filtering_name) do
      {:ok, [sorting_params: sorting_params, filtering_params: filtering_params]}
    end
  end

  defp build_sorting_params(nil, nil), do: {:ok, nil}
  defp build_sorting_params("", _), do: {:ok, nil}
  defp build_sorting_params(_, ""), do: {:ok, nil}

  defp build_sorting_params(order, field),
    do: SortingParams.new(%{field: field, ordering: order}, @valid_sorting_fields)

  defp build_filtering_params(nil), do: {:ok, nil}
  defp build_filtering_params(""), do: {:ok, nil}

  defp build_filtering_params(name),
    do: FilteringParams.new(%{contains_string_filter: name, field: "name"}, @valid_filtering_fields)
end
