defmodule NflRushingWeb.PlayerLive.Index do
  use NflRushingWeb, :live_view

  alias NflRushing.Query.{FilteringParams, SortingParams}
  alias NflRushing.Records
  alias NflRushing.Records.Player
  alias Phoenix.LiveView.Socket

  @valid_sorting_fields [
    :name,
    :total_rushing_yards,
    :longest_rush,
    :rushing_touchdowns
  ]

  @valid_filtering_fields [:name]

  @impl true
  def mount(_params, _session, socket = %Socket{}) do
    {:ok, assign_defaults(socket)}
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

  @impl true
  def handle_event("filter_data", %{"filtering" => %{"name" => name}}, socket = %Socket{}) do
    {:noreply,
     socket
     |> assign(filtering_name: name)
     |> assign_players_list()}
  end

  defp assign_players_list(socket = %Socket{}) do
    with {:ok, sorting_params} <- build_sorting_params(socket.assigns),
         {:ok, filtering_params} <- build_filtering_params(socket.assigns) do
      players_list = Records.list_players(sorting_params: sorting_params, filtering_params: filtering_params)

      assign(socket, :players, players_list)
    end
  end

  defp build_sorting_params(%{sort_order: nil, sort_field: nil}), do: {:ok, nil}

  defp build_sorting_params(%{sort_order: order, sort_field: field}),
    do: SortingParams.new(%{field: field, ordering: order}, @valid_sorting_fields)

  defp build_filtering_params(%{filtering_name: nil}), do: {:ok, nil}

  defp build_filtering_params(%{filtering_name: name}),
    do: FilteringParams.new(%{contains_string_filter: name, field: "name"}, @valid_filtering_fields)

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
