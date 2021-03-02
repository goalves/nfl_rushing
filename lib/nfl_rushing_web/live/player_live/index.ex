defmodule NflRushingWeb.PlayerLive.Index do
  use NflRushingWeb, :live_view

  alias Phoenix.LiveView.Socket
  alias NflRushing.Records
  alias NflRushing.Records.Player
  alias NflRushing.Query.SortingParams

  @valid_sorting_fields [
    :name,
    :total_rushing_yards,
    :longest_rush,
    :rushing_touchdowns
  ]

  @impl true
  def mount(_params, _session, socket = %Socket{}) do
    {:ok, socket |> assign(:sort_order, nil) |> assign(:sort_field, nil) |> assign_players_list()}
  end

  @impl true
  def handle_params(params, _url, socket = %Socket{}) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Players")
  end

  @impl true
  def handle_event(
        "sort_data",
        %{"sorting" => %{"order" => order, "field" => field}},
        socket = %Socket{}
      ) do
    {:noreply,
     socket
     |> assign(sort_order: order, sort_field: field)
     |> assign_players_list()}
  end

  defp assign_players_list(socket = %Socket{}) do
    with {:ok, sorting_params} <- build_sorting_params(socket.assigns) do
      players_list = Records.list_players(sorting_params: sorting_params)

      assign(socket, :players, players_list)
    end
  end

  defp build_sorting_params(%{sort_order: nil, sort_field: nil}), do: {:ok, nil}

  defp build_sorting_params(%{sort_order: order, sort_field: field}),
    do: SortingParams.new(%{field: field, ordering: order}, @valid_sorting_fields)

  @spec format_longest_rush(Player.t()) :: binary()
  def format_longest_rush(player = %Player{}) do
    touchdown_identifier = if player.longest_rush_had_a_touchdown?, do: "T", else: ""

    "#{player.longest_rush}#{touchdown_identifier}"
  end
end
