defmodule NflRushing.RecordsTest do
  use NflRushing.DataCase

  import NflRushing.Factory

  alias Ecto.UUID
  alias NflRushing.Query.{FilteringParams, SortingParams}
  alias NflRushing.Records.Player
  alias NflRushing.{Records, Repo}

  describe "list_players/0" do
    test "returns all players" do
      player = insert(:player)
      assert Records.list_players() == [player]
    end

    test "returns all players sorted" do
      [first_player, second_player] =
        1..2
        |> Enum.map(fn _ -> insert(:player) end)
        |> Enum.sort_by(& &1.name, &<=/2)

      assert [first_player, second_player] ==
               Records.list_players(sorting_params: %SortingParams{ordering: :asc, field: :name})
    end

    test "returns filtered players" do
      first_player = insert(:player, name: "John")
      _second_player = insert(:player, name: "Doe")

      options = [filtering_params: %FilteringParams{contains_string_filter: first_player.name, field: :name}]

      assert [first_player] == Records.list_players(options)
    end
  end

  describe "insert_players" do
    test "inserts a list of player structures" do
      players = build_list(2, :player)
      player_names = Enum.map(players, & &1.name)

      assert {:ok, 2} == Records.insert_players(players)
      assert [first_player, second_player] = Repo.all(Player)
      assert first_player.name in player_names
      assert second_player.name in player_names
    end

    test "ignores ids on player structures" do
      id = UUID.generate()
      player = build(:player, id: id)

      assert {:ok, 1} == Records.insert_players([player])
      assert [%Player{id: fetched_id}] = Repo.all(Player)
      refute fetched_id == id
    end
  end
end
