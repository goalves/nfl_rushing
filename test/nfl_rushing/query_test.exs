defmodule NflRushing.QueryTest do
  use NflRushing.DataCase

  alias NflRushing.Query
  alias NflRushing.Query.{FilteringParams, SortingParams}

  defmodule TestQueriable do
    use Ecto.Schema
    schema("test_queriable", do: [])
  end

  describe "sort/2" do
    test "returns a query with an order by statement" do
      assert Enum.all?([:asc, :desc], fn ordering ->
               sorting_params = %SortingParams{field: :field, ordering: ordering}
               queriable = Query.sort(TestQueriable, sorting_params)

               expected_query =
                 ~s"#Ecto.Query<from t0 in NflRushing.QueryTest.TestQueriable, order_by: [#{ordering}: t0.#{
                   sorting_params.field
                 }]>"

               assert inspect(queriable) == expected_query
             end)
    end

    test "returns the given queriable if nil argument is passed",
      do: assert(TestQueriable == Query.sort(TestQueriable, nil))
  end

  describe "filter/2" do
    test "returns a query filtered with an ilike sentence for a contains string filter" do
      field = :field
      filter = Faker.Person.first_name()

      filtering_params = %FilteringParams{contains_string_filter: filter, field: field}
      queriable = Query.filter(TestQueriable, filtering_params)

      expected_query =
        ~s"#Ecto.Query<from t0 in NflRushing.QueryTest.TestQueriable, where: ilike(t0.#{field}, ^\"%#{filter}%\")>"

      assert inspect(queriable) == expected_query
    end

    test "returns the given queriable if nil argument is passed",
      do: assert(TestQueriable == Query.filter(TestQueriable, nil))
  end
end
