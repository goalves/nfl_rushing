defmodule NflRushing.Records.Player do
  @moduledoc """
  Schema module that represents player records in the system.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset

  @type t :: %__MODULE__{}

  @required_fields [
    :name,
    :team,
    :position,
    :attempts_per_game,
    :rushing_attemps,
    :total_rushing_yards,
    :rushing_average_yards_per_attempt,
    :rushing_yards_per_game,
    :rushing_touchdowns,
    :longest_rush,
    :longest_rush_had_a_touchdown?,
    :rushing_first_downs,
    :rushing_first_down_percentage,
    :rushing_20_yards_each,
    :rushing_40_yards_each,
    :fumbles
  ]

  @fields @required_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "players" do
    field :attempts_per_game, :float
    field :fumbles, :integer
    field :longest_rush, :integer
    field :longest_rush_had_a_touchdown?, :boolean, default: false
    field :name, :string
    field :position, :string
    field :rushing_20_yards_each, :integer
    field :rushing_40_yards_each, :integer
    field :rushing_attemps, :integer
    field :rushing_average_yards_per_attempt, :float
    field :rushing_first_down_percentage, :float
    field :rushing_first_downs, :integer
    field :rushing_touchdowns, :integer
    field :rushing_yards_per_game, :float
    field :team, :string
    field :total_rushing_yards, :float
  end

  @doc false
  @spec changeset(t(), map()) :: Changeset.t()
  def changeset(%__MODULE__{} = player, attributes) when is_map(attributes) do
    player
    |> cast(attributes, @fields)
    |> validate()
  end

  defp validate(changeset = %Changeset{}) do
    changeset
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 255)
    |> validate_length(:team, max: 255)
    |> validate_length(:position, max: 255)
    |> validate_number(:fumbles, greater_than_or_equal_to: 0)
    |> validate_number(:attempts_per_game, greater_than_or_equal_to: 0)
    |> validate_number(:longest_rush, greater_than_or_equal_to: 0)
    |> validate_number(:rushing_20_yards_each, greater_than_or_equal_to: 0)
    |> validate_number(:rushing_40_yards_each, greater_than_or_equal_to: 0)
    |> validate_number(:rushing_attemps, greater_than_or_equal_to: 0)
    |> validate_number(:rushing_average_yards_per_attempt, greater_than_or_equal_to: 0)
    |> validate_number(:rushing_first_down_percentage, greater_than_or_equal_to: 0)
    |> validate_number(:rushing_first_downs, greater_than_or_equal_to: 0)
    |> validate_number(:rushing_touchdowns, greater_than_or_equal_to: 0)
    |> validate_number(:rushing_yards_per_game, greater_than_or_equal_to: 0)
    |> validate_number(:total_rushing_yards, greater_than_or_equal_to: 0)
  end

  @spec new(map()) :: {:ok, t()} | {:error, Changeset.t()}
  def new(data) when is_map(data) do
    %__MODULE__{}
    |> changeset(data)
    |> case do
      changeset = %Changeset{valid?: true} -> {:ok, apply_changes(changeset)}
      changeset = %Changeset{valid?: false} -> {:error, changeset}
    end
  end
end
