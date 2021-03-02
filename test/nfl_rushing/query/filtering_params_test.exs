defmodule NflRushing.Query.FilteringParamsTest do
  use NflRushing.DataCase

  alias Ecto.Changeset
  alias NflRushing.Query.FilteringParams

  describe "new/2" do
    test "returns a sorting params structure" do
      filter = Faker.Pizza.cheese()
      field = Faker.Pizza.sauce()
      field_atom = String.to_atom(field)
      attributes = %{contains_string_filter: filter, field: field}

      assert {:ok, %FilteringParams{contains_string_filter: filter, field: field_atom}} ==
               FilteringParams.new(attributes, [field_atom])
    end

    test "returns an invalid changeset for missing attributes",
      do: assert({:error, %Changeset{valid?: false}} = FilteringParams.new(%{}, []))

    test "returns an error if trying to convert a field that is not passed as an argument to an atom" do
      filter = Faker.Pizza.cheese()
      field = Faker.Pizza.sauce()
      attributes = %{contains_string_filter: filter, field: field}

      assert {:error, :invalid_field_being_converted} == FilteringParams.new(attributes, [:other_field])
    end
  end
end
