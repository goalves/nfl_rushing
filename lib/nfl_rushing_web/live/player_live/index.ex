defmodule NflRushingWeb.PlayerLive.Index do
  use NflRushingWeb, :live_view

  alias NflRushing.Records
  alias NflRushing.Records.Player

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :players, list_players())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Player")
    |> assign(:player, Records.get_player!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Player")
    |> assign(:player, %Player{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Players")
    |> assign(:player, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    player = Records.get_player!(id)
    {:ok, _} = Records.delete_player(player)

    {:noreply, assign(socket, :players, list_players())}
  end

  defp list_players do
    Records.list_players()
  end
end
