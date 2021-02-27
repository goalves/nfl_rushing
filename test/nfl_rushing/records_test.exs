defmodule NflRushing.RecordsTest do
  use NflRushing.DataCase

  alias NflRushing.Records

  describe "players" do
    alias NflRushing.Records.Player

    @valid_attrs %{attempts_per_game: 120.5, fumbles: 42, longest_rush: 42, longest_rush_had_a_touchdown?: true, name: "some name", position: "some position", rushing_20_yards_each: 42, rushing_40_yards_each: 42, rushing_attemps: 42, rushing_average_yards_per_attempt: 120.5, rushing_first_down_percentage: 120.5, rushing_first_downs: 42, rushing_touchdowns: 42, rushing_yards_per_game: 120.5, team: "some team", total_rushing_yards: 120.5}
    @update_attrs %{attempts_per_game: 456.7, fumbles: 43, longest_rush: 43, longest_rush_had_a_touchdown?: false, name: "some updated name", position: "some updated position", rushing_20_yards_each: 43, rushing_40_yards_each: 43, rushing_attemps: 43, rushing_average_yards_per_attempt: 456.7, rushing_first_down_percentage: 456.7, rushing_first_downs: 43, rushing_touchdowns: 43, rushing_yards_per_game: 456.7, team: "some updated team", total_rushing_yards: 456.7}
    @invalid_attrs %{attempts_per_game: nil, fumbles: nil, longest_rush: nil, longest_rush_had_a_touchdown?: nil, name: nil, position: nil, rushing_20_yards_each: nil, rushing_40_yards_each: nil, rushing_attemps: nil, rushing_average_yards_per_attempt: nil, rushing_first_down_percentage: nil, rushing_first_downs: nil, rushing_touchdowns: nil, rushing_yards_per_game: nil, team: nil, total_rushing_yards: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Records.create_player()

      player
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Records.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Records.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Records.create_player(@valid_attrs)
      assert player.attempts_per_game == 120.5
      assert player.fumbles == 42
      assert player.longest_rush == 42
      assert player.longest_rush_had_a_touchdown? == true
      assert player.name == "some name"
      assert player.position == "some position"
      assert player.rushing_20_yards_each == 42
      assert player.rushing_40_yards_each == 42
      assert player.rushing_attemps == 42
      assert player.rushing_average_yards_per_attempt == 120.5
      assert player.rushing_first_down_percentage == 120.5
      assert player.rushing_first_downs == 42
      assert player.rushing_touchdowns == 42
      assert player.rushing_yards_per_game == 120.5
      assert player.team == "some team"
      assert player.total_rushing_yards == 120.5
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Records.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, %Player{} = player} = Records.update_player(player, @update_attrs)
      assert player.attempts_per_game == 456.7
      assert player.fumbles == 43
      assert player.longest_rush == 43
      assert player.longest_rush_had_a_touchdown? == false
      assert player.name == "some updated name"
      assert player.position == "some updated position"
      assert player.rushing_20_yards_each == 43
      assert player.rushing_40_yards_each == 43
      assert player.rushing_attemps == 43
      assert player.rushing_average_yards_per_attempt == 456.7
      assert player.rushing_first_down_percentage == 456.7
      assert player.rushing_first_downs == 43
      assert player.rushing_touchdowns == 43
      assert player.rushing_yards_per_game == 456.7
      assert player.team == "some updated team"
      assert player.total_rushing_yards == 456.7
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Records.update_player(player, @invalid_attrs)
      assert player == Records.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Records.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Records.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Records.change_player(player)
    end
  end
end
