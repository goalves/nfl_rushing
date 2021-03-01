defmodule NflRushing.Records do
  @moduledoc """
  The Records context.
  """

  import Ecto.Query, warn: false

  alias Ecto.UUID
  alias NflRushing.Repo
  alias NflRushing.Records.Player

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Repo.all(Player)
  end

  @doc """
  Insert a list of players.
  """
  @spec insert_players([Player.t()]) :: {:ok, integer()}
  def insert_players(players) when is_list(players) do
    players_data = Enum.map(players, &prepare_insert/1)

    Player
    |> Repo.insert_all(players_data)
    |> case do
      {inserted_values, _} when is_integer(inserted_values) -> {:ok, inserted_values}
      error -> {:error, error}
    end
  end

  defp prepare_insert(player = %Player{}),
    do: player |> Map.drop([:__meta__, :__struct__]) |> Map.put(:id, UUID.generate())
end
