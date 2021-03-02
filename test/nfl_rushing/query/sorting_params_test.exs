defmodule NflRushing.Query.SortingParamsTest do
  use NflRushing.DataCase

  alias Ecto.Changeset
  alias NflRushing.Query.SortingParams

  describe "new/2" do
    test "returns a sorting params structure" do
      attributes = %{ordering: "asc", field: "field"}
      assert {:ok, %SortingParams{ordering: :asc, field: :field}} == SortingParams.new(attributes, [:field])
    end

    test "returns an invalid changeset for missing attributes",
      do: assert({:error, %Changeset{valid?: false}} = SortingParams.new(%{}, []))

    test "returns an error if trying to convert a field that is not passed as an argument to an atom" do
      attributes = %{ordering: "asc", field: "field"}
      assert {:error, :invalid_field_being_converted} == SortingParams.new(attributes, [:other_field])
    end
  end
end
