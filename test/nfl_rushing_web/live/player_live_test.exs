defmodule NflRushingWeb.PlayerLiveTest do
  use NflRushingWeb.ConnCase

  import Phoenix.LiveViewTest
  import NflRushing.Factory

  alias NflRushingWeb.PlayerLive.Index

  describe "index" do
    test "lists all players", %{conn: conn} do
      player = insert(:player)
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

    test "filters players", %{conn: conn} do
      first_player = insert(:player, name: "John")
      second_player = insert(:player, name: "Doe")

      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      html =
        index_live
        |> form("#filtering-form", filtering: %{name: first_player.name})
        |> render_submit()

      assert html =~ "Filtering data..."
      assert html =~ first_player.name
      refute html =~ second_player.name
    end
  end

  describe "index_format_longest_rush/1" do
    test "returns formatted value when it has a touchdown" do
      player = build(:player, longest_rush_had_a_touchdown?: true)
      assert Index.format_longest_rush(player) == "#{player.longest_rush}T"
    end

    test "returns formatted value when it does not have a touchdown" do
      player = build(:player, longest_rush_had_a_touchdown?: false)
      assert Index.format_longest_rush(player) == "#{player.longest_rush}"
    end
  end
end
