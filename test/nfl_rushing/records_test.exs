defmodule NflRushing.RecordsTest do
  use NflRushing.DataCase

  import NflRushing.Factory

  alias Ecto.UUID
  alias NflRushing.Query.{FilteringParams, SortingParams}
  alias NflRushing.Records.Player
  alias NflRushing.{Records, Repo}
  alias Scrivener.Page

  describe "list_players/1" do
    test "returns all players" do
      player = insert(:player)
      assert Records.list_players() == [player]
    end

    test "returns all players sorted" do
      [first_player, second_player] =
        1..2
        |> Enum.map(fn _ -> insert(:player) end)
        |> Enum.sort_by(& &1.name, &<=/2)

      options = [sorting_params: %SortingParams{ordering: :asc, field: :name}]
      assert [first_player, second_player] == Records.list_players(options)
    end

    test "returns filtered players" do
      first_player = insert(:player, name: "John")
      _second_player = insert(:player, name: "Doe")

      options = [filtering_params: %FilteringParams{contains_string_filter: first_player.name, field: :name}]
      assert [first_player] == Records.list_players(options)
    end
  end

  describe "list_players_paginated/1" do
    test "returns paginated element with players" do
      insert_list(5, :player)

      assert %Page{entries: entries, page_number: 1, total_entries: 5, total_pages: 3, page_size: 2} =
               Records.list_players_paginated(page_size: 2)

      assert Enum.count(entries) == 2
    end

    test "accepts filtering on paginating players" do
      [first_player | _] = insert_list(5, :player, name: "John")
      insert(:player, name: "Doe")

      options = [filtering_params: %FilteringParams{contains_string_filter: first_player.name, field: :name}]
      assert %Page{total_entries: 5} = Records.list_players_paginated([page_size: 1], options)
    end

    test "accepts sorting when paginating playesr" do
      [first_player, _second_player] =
        1..2
        |> Enum.map(fn _ -> insert(:player) end)
        |> Enum.sort_by(& &1.name, &<=/2)

      options = [sorting_params: %SortingParams{ordering: :asc, field: :name}]

      assert %Page{total_entries: 2, entries: [fetched_first_player]} =
               Records.list_players_paginated([page_size: 1], options)

      assert fetched_first_player.id == first_player.id
    end
  end

  describe "insert_players/1" do
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
