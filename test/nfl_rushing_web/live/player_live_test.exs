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

      assert html =~ "Players"
      assert html =~ player.name
    end

    test "sorts players", %{conn: conn} do
      [first_player, second_player] = 2 |> insert_list(:player) |> Enum.sort_by(& &1.name, &>=/2)

      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      html =
        index_live
        |> form("#sorting-form", sorting: %{order: "desc", field: "name"})
        |> render_submit()

      assert html =~ "Sorting data..."
      assert html =~ Regex.compile!("#{first_player.name}.*#{second_player.name}")
    end
  end
end
