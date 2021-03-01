defmodule NflRushing.RecordsTest do
  use NflRushing.DataCase

  import NflRushing.Factory

  alias Ecto.UUID
  alias NflRushing.{Records, Repo}
  alias NflRushing.Records.Player

  defp create_player(_) do
    player = insert(:player)
    %{player: player}
  end

  describe "list_players/0" do
    setup [:create_player]

    test "returns all players", %{player: player} do
      assert Records.list_players() == [player]
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
