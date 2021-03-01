defmodule NflRushing.Records.PlayerTest do
  use NflRushing.DataCase

  import NflRushing.Factory

  alias Ecto.Changeset
  alias NflRushing.Records.Player

  defp player_attributes(_), do: %{player_attributes: params_for(:player)}

  describe "changeset/2" do
    setup [:player_attributes]

    test "returns a valid changeset", %{player_attributes: attributes} do
      assert %Changeset{valid?: true} = Player.changeset(%Player{}, attributes)
    end

    test "returns an invalid changeset for missing attributes",
      do: assert(%Changeset{valid?: false} = Player.changeset(%Player{}, %{}))

    test "returns an invalid changeset when string fields are too long", %{player_attributes: attributes} do
      string_fields = [:name, :team, :position]
      long_string = Faker.String.base64(256)

      assert Enum.all?(string_fields, fn field ->
               invalid_attributes = Map.put(attributes, field, long_string)
               assert changeset = %Changeset{valid?: false} = Player.changeset(%Player{}, invalid_attributes)
               assert changeset_errors = errors_on(changeset)
               assert changeset_errors[field] == ["should be at most 255 character(s)"]
             end)
    end

    test "returns an invalid changeset when numerical fields are negative", %{player_attributes: attributes} do
      numerical_fields = [
        :attempts_per_game,
        :fumbles,
        :longest_rush,
        :rushing_20_yards_each,
        :rushing_40_yards_each,
        :rushing_attemps,
        :rushing_first_downs,
        :rushing_touchdowns,
        :rushing_average_yards_per_attempt,
        :rushing_first_down_percentage,
        :rushing_yards_per_game,
        :total_rushing_yards
      ]

      negative_value = -1

      assert Enum.all?(numerical_fields, fn field ->
               invalid_attributes = Map.put(attributes, field, negative_value)
               assert changeset = %Changeset{valid?: false} = Player.changeset(%Player{}, invalid_attributes)
               assert changeset_errors = errors_on(changeset)
               assert changeset_errors[field] == ["must be greater than or equal to 0"]
             end)
    end
  end

  describe "new/1" do
    setup [:player_attributes]

    test "returns a player structure with the data provided", %{player_attributes: attributes} do
      assert {:ok, player = %Player{}} = Player.new(attributes)
      assert player.name == attributes.name
    end

    test "returns an error and a changeset when data is not valid",
      do: assert({:error, %Changeset{}} = Player.new(%{}))
  end
end
