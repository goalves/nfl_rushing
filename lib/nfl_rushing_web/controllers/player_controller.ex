defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.{Data, Records}
  alias NflRushing.Query.PlayerParams
  alias Plug.Conn

  action_fallback(NflRushingWeb.DefaultFallbackController)

  @spec export_csv(Conn.t(), map()) :: Conn.t()
  def export_csv(conn = %Conn{}, %{
        "sort_order" => sort_order,
        "sort_field" => sort_field,
        "filtering_name" => filtering_name
      }) do
    with {:ok, player_params} <- PlayerParams.build(sort_order, sort_field, filtering_name) do
      csv_binary = player_params |> Records.list_players() |> Data.export_as_csv()
      send_download(conn, {:binary, csv_binary}, filename: "rushing_export.csv")
    end
  end
end
