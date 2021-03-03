defmodule NflRushingWeb.PlayerLive.Index do
  use NflRushingWeb, :live_view

  alias NflRushing.Query.PlayerParams
  alias NflRushing.Records
  alias NflRushing.Records.Player
  alias Phoenix.LiveView.Socket
  alias Scrivener.Page

  @impl true
  def mount(_params, _session, socket = %Socket{}) do
    {:ok, assign_defaults(socket)}
  end

  @impl true
  def handle_params(params, _url, socket = %Socket{}) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "NFL Rushing")
  end

  @impl true
  def handle_event("sort", %{"field" => field}, socket = %Socket{}) do
    order = cycle_sort_order(socket.assigns.sort_order)

    {:noreply,
     socket
     |> assign(sort_order: order, sort_field: field)
     |> assign_players_list()}
  end

  @impl true
  def handle_event("filter", %{"filtering" => name}, socket = %Socket{}) do
    {:noreply,
     socket
     |> assign(filtering_name: name)
     |> assign_players_list()}
  end

  @impl true
  def handle_event("change-page-size", %{"page_size" => page_size}, socket = %Socket{}) do
    {:noreply,
     socket
     |> assign(page_size: String.to_integer(page_size))
     |> assign(page_number: 1)
     |> assign_players_list()}
  end

  def handle_event("change-page", %{"page" => page}, socket = %Socket{}) do
    {:noreply,
     socket
     |> assign(page_number: String.to_integer(page))
     |> assign_players_list()}
  end

  defp assign_players_list(socket = %Socket{assigns: assigns}) do
    %{
      sort_order: sort_order,
      sort_field: sort_field,
      filtering_name: filtering_name,
      page_size: page_size,
      page_number: page_number
    } = assigns

    pagination_params = [page_size: page_size, page: page_number]

    with {:ok, player_params} <- PlayerParams.build(sort_order, sort_field, filtering_name) do
      %Page{entries: players_list, page_number: current_page, total_pages: total_pages} =
        Records.list_players_paginated(pagination_params, player_params)

      socket
      |> assign(:players, players_list)
      |> assign(:page_number, current_page)
      |> assign(:total_pages, total_pages)
    end
  end

  @spec format_longest_rush(Player.t()) :: binary()
  def format_longest_rush(player = %Player{}) do
    touchdown_identifier = if player.longest_rush_had_a_touchdown?, do: "T", else: ""

    "#{player.longest_rush}#{touchdown_identifier}"
  end

  defp sort_order_icon(column, sort_field, "asc") when column == sort_field, do: "▲"
  defp sort_order_icon(column, sort_field, "desc") when column == sort_field, do: "▼"
  defp sort_order_icon(_, _, _), do: "↕️"

  defp cycle_sort_order("asc"), do: "desc"
  defp cycle_sort_order("desc"), do: ""
  defp cycle_sort_order(_), do: "asc"

  defp assign_defaults(socket = %Socket{}) do
    socket
    |> assign(:sort_order, nil)
    |> assign(:sort_field, nil)
    |> assign(:filtering_name, nil)
    |> assign(:page_size, 25)
    |> assign(:page_number, 1)
    |> assign(:total_pages, 1)
    |> assign_players_list()
  end
end
