defmodule NflRushingWeb.PlayerLiveTest do
  use NflRushingWeb.ConnCase

  import Phoenix.LiveViewTest
  import NflRushing.Factory

  defp create_player(_) do
    player = insert(:player)
    %{player: player}
  end

  describe "index" do
    setup [:create_player]

    test "lists all players", %{conn: conn, player: player} do
      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index))

      assert html =~ "Listing Players"
      assert html =~ player.name
    end
  end
end
