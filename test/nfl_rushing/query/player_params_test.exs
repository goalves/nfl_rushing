defmodule NflRushing.Query.PlayerParamsTest do
  use NflRushing.DataCase

  alias Ecto.Changeset
  alias NflRushing.Query.{FilteringParams, PlayerParams, SortingParams}

  describe "build/3" do
    test "returns sorting params and filtering params structures" do
      assert {:ok,
              [
                sorting_params: %SortingParams{ordering: :asc, field: :name},
                filtering_params: %FilteringParams{contains_string_filter: "filter"}
              ]} = PlayerParams.build("asc", "name", "filter")
    end

    test "returns an error for invalid elements" do
      assert {:error, %Changeset{valid?: false}} = PlayerParams.build(:asc, :invaild, "invalid")
    end
  end
end
