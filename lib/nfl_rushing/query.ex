defmodule NflRushing.Query do
  import Ecto.Query
  alias NflRushing.Query.{FilteringParams, SortingParams}

  @valid_ordering [:asc, :desc]

  def sort(queriable, %SortingParams{field: field, ordering: ordering})
      when ordering in @valid_ordering and is_atom(field),
      do: order_by(queriable, [element], {^ordering, field(element, ^field)})

  def sort(queriable, nil), do: queriable

  def filter(queriable, %FilteringParams{contains_string_filter: string, field: field}) do
    where(queriable, [element], ilike(field(element, ^field), ^"%#{string}%"))
  end

  def filter(queriable, nil), do: queriable
end
