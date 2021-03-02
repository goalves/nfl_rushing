defmodule NflRushing.QueryTest do
  use NflRushing.DataCase

  alias NflRushing.Query
  alias NflRushing.Query.SortingParams

  defmodule TestQueriable do
    use Ecto.Schema
    schema("test_queriable", do: [])
  end

  describe "sort/2" do
    test "returns a query with an order by statement" do
      sorting_params = %SortingParams{field: :field, ordering: :asc}
      queriable = Query.sort(TestQueriable, sorting_params)

      expected_query =
        ~s"#Ecto.Query<from t0 in NflRushing.QueryTest.TestQueriable, order_by: [#{sorting_params.ordering}: t0.#{
          sorting_params.field
        }]>"

      assert inspect(queriable) == expected_query
    end

    test "returns the given queriable if nil argument is passed",
      do: assert(TestQueriable == Query.sort(TestQueriable, nil))
  end
end