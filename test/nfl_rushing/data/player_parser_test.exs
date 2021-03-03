defmodule NflRushing.Data.PlayerParserTest do
  use NflRushing.DataCase

  import ExUnit.CaptureLog
  import NflRushing.Factory

  alias Ecto.Changeset
  alias NflRushing.Data.PlayerParser
  alias NflRushing.Records.Player

  defp build_importable_data(_), do: %{data: params_for(:importable_data)}

  describe "parse_record/1" do
    setup [:build_importable_data]

    test "parses an expected map structure into a NflRushing.Records.Player structure", %{data: data} do
      {lng, _} = Integer.parse(data["Lng"])
      assert {:ok, player = %Player{}} = PlayerParser.parse_record(data)

      assert player.name == data["Player"]
      assert player.team == data["Team"]
      assert player.position == data["Pos"]
      assert player.attempts_per_game == data["Att/G"]
      assert player.rushing_attemps == data["Att"]
      assert player.total_rushing_yards == data["Yds"]
      assert player.rushing_average_yards_per_attempt == data["Avg"]
      assert player.rushing_yards_per_game == data["Yds/G"]
      assert player.rushing_touchdowns == data["TD"]
      assert player.longest_rush == lng
      assert player.rushing_first_down_percentage == data["1st%"]
      assert player.rushing_20_yards_each == data["20+"]
      assert player.rushing_40_yards_each == data["40+"]
      assert player.fumbles == data["FUM"]
      assert player.longest_rush_had_a_touchdown? == false
      assert player.rushing_first_downs == data["1st"]
    end

    test "parses longest rushes with touchdowns", %{data: data} do
      data_with_touchdowns = Map.put(data, "Lng", "42T")

      assert {:ok, %Player{longest_rush: 42, longest_rush_had_a_touchdown?: true}} =
               PlayerParser.parse_record(data_with_touchdowns)
    end

    test "parses total rushing yards separated by commas", %{data: data} do
      data_with_rushing_yards_separated_by_commas = Map.put(data, "Yds", "1,234")

      assert {:ok, %Player{total_rushing_yards: 1234.0}} =
               PlayerParser.parse_record(data_with_rushing_yards_separated_by_commas)
    end

    test "logs an error when fails to parse" do
      parse_function = fn -> assert {:error, %Changeset{}} = PlayerParser.parse_record(%{}) end
      assert capture_log(parse_function) =~ "Failed to parse element:"
    end

    test "returns an error with invalid data if provided data is not a map",
      do: assert({:error, :invalid_data} = PlayerParser.parse_record([]))
  end
end
