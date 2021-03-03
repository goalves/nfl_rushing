defmodule NflRushing.Records do
  @moduledoc """
  The Records context.
  """

  import Ecto.Query, warn: false

  alias Ecto.UUID
  alias NflRushing.Records.Player
  alias NflRushing.{Query, Repo}

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players(opts \\ []) do
    opts
    |> list_players_query()
    |> Repo.all()
  end

  @doc """
  Returns a list of players paginated.
  """
  def list_players_paginated(pagination_params, opts \\ []) do
    opts
    |> list_players_query()
    |> Repo.paginate(pagination_params)
  end

  defp list_players_query(opts) do
    sorting_params = Keyword.get(opts, :sorting_params)
    filtering_params = Keyword.get(opts, :filtering_params)

    Player
    |> Query.sort(sorting_params)
    |> Query.filter(filtering_params)
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
