defmodule NflRushingWeb.PlayerControllerTest do
  use NflRushingWeb.ConnCase

  import NflRushing.Factory

  describe "POST /players/export" do
    test "returns a download file", %{conn: conn} do
      player = insert(:player)
      params = %{"sort_order" => nil, "sort_field" => nil, "filtering_name" => nil}

      conn = post(conn, Routes.player_path(conn, :export_csv), params)
      assert conn.resp_body =~ "#{player.name}"
    end

    test "accepts sorting", %{conn: conn} do
      [first_player, second_player] =
        1..2
        |> Enum.map(fn _ -> insert(:player) end)
        |> Enum.sort_by(& &1.name, &<=/2)

      params = %{"sort_order" => "asc", "sort_field" => "name", "filtering_name" => nil}
      conn = post(conn, Routes.player_path(conn, :export_csv), params)
      assert String.replace(conn.resp_body, "\n", "") =~ Regex.compile!("#{first_player.name}?.*#{second_player.name}")
    end

    test "returns an error if parameters are invalid", %{conn: conn} do
      params = %{"sort_order" => "invalid", "sort_field" => "name", "filtering_name" => nil}

      assert conn |> post(Routes.player_path(conn, :export_csv), params) |> json_response(422) == %{
               "errors" => %{"ordering" => ["is invalid"]}
             }
    end
  end
end
