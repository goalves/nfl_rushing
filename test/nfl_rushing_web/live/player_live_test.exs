defmodule NflRushingWeb.PlayerLiveTest do
  use NflRushingWeb.ConnCase

  import Phoenix.LiveViewTest

  alias NflRushing.Records

  @create_attrs %{attempts_per_game: 120.5, fumbles: 42, longest_rush: 42, longest_rush_had_a_touchdown?: true, name: "some name", position: "some position", rushing_20_yards_each: 42, rushing_40_yards_each: 42, rushing_attemps: 42, rushing_average_yards_per_attempt: 120.5, rushing_first_down_percentage: 120.5, rushing_first_downs: 42, rushing_touchdowns: 42, rushing_yards_per_game: 120.5, team: "some team", total_rushing_yards: 120.5}
  @update_attrs %{attempts_per_game: 456.7, fumbles: 43, longest_rush: 43, longest_rush_had_a_touchdown?: false, name: "some updated name", position: "some updated position", rushing_20_yards_each: 43, rushing_40_yards_each: 43, rushing_attemps: 43, rushing_average_yards_per_attempt: 456.7, rushing_first_down_percentage: 456.7, rushing_first_downs: 43, rushing_touchdowns: 43, rushing_yards_per_game: 456.7, team: "some updated team", total_rushing_yards: 456.7}
  @invalid_attrs %{attempts_per_game: nil, fumbles: nil, longest_rush: nil, longest_rush_had_a_touchdown?: nil, name: nil, position: nil, rushing_20_yards_each: nil, rushing_40_yards_each: nil, rushing_attemps: nil, rushing_average_yards_per_attempt: nil, rushing_first_down_percentage: nil, rushing_first_downs: nil, rushing_touchdowns: nil, rushing_yards_per_game: nil, team: nil, total_rushing_yards: nil}

  defp fixture(:player) do
    {:ok, player} = Records.create_player(@create_attrs)
    player
  end

  defp create_player(_) do
    player = fixture(:player)
    %{player: player}
  end

  describe "Index" do
    setup [:create_player]

    test "lists all players", %{conn: conn, player: player} do
      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index))

      assert html =~ "Listing Players"
      assert html =~ player.name
    end

    test "saves new player", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      assert index_live |> element("a", "New Player") |> render_click() =~
               "New Player"

      assert_patch(index_live, Routes.player_index_path(conn, :new))

      assert index_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#player-form", player: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.player_index_path(conn, :index))

      assert html =~ "Player created successfully"
      assert html =~ "some name"
    end

    test "updates player in listing", %{conn: conn, player: player} do
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      assert index_live |> element("#player-#{player.id} a", "Edit") |> render_click() =~
               "Edit Player"

      assert_patch(index_live, Routes.player_index_path(conn, :edit, player))

      assert index_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#player-form", player: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.player_index_path(conn, :index))

      assert html =~ "Player updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes player in listing", %{conn: conn, player: player} do
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      assert index_live |> element("#player-#{player.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#player-#{player.id}")
    end
  end

  describe "Show" do
    setup [:create_player]

    test "displays player", %{conn: conn, player: player} do
      {:ok, _show_live, html} = live(conn, Routes.player_show_path(conn, :show, player))

      assert html =~ "Show Player"
      assert html =~ player.name
    end

    test "updates player within modal", %{conn: conn, player: player} do
      {:ok, show_live, _html} = live(conn, Routes.player_show_path(conn, :show, player))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Player"

      assert_patch(show_live, Routes.player_show_path(conn, :edit, player))

      assert show_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#player-form", player: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.player_show_path(conn, :show, player))

      assert html =~ "Player updated successfully"
      assert html =~ "some updated name"
    end
  end
end
