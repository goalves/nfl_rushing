defmodule NflRushingWeb.PlayerLive.Index do
  use NflRushingWeb, :live_view

  alias NflRushing.Query.PlayerParams
  alias NflRushing.Records
  alias NflRushing.Records.Player
  alias Phoenix.LiveView.Socket

  @impl true
  def mount(_params, _session, socket = %Socket{}) do
    {:ok, assign_defaults(socket)}
  end

  @impl true
  def handle_params(params, _url, socket = %Socket{}) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Players")
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

  @impl true
  def handle_event("filter_data", %{"filtering" => %{"name" => name}}, socket = %Socket{}) do
    {:noreply,
     socket
     |> assign(filtering_name: name)
     |> assign_players_list()}
  end

  defp assign_players_list(socket = %Socket{assigns: assigns}) do
    %{sort_order: sort_order, sort_field: sort_field, filtering_name: filtering_name} = assigns

    with {:ok, player_params} <- PlayerParams.build(sort_order, sort_field, filtering_name) do
      players_list = Records.list_players(player_params)
      assign(socket, :players, players_list)
    end
  end

  @spec format_longest_rush(Player.t()) :: binary()
  def format_longest_rush(player = %Player{}) do
    touchdown_identifier = if player.longest_rush_had_a_touchdown?, do: "T", else: ""

    "#{player.longest_rush}#{touchdown_identifier}"
  end

  defp assign_defaults(socket = %Socket{}) do
    socket
    |> assign(:sort_order, nil)
    |> assign(:sort_field, nil)
    |> assign(:filtering_name, nil)
    |> assign_players_list()
  end
end
