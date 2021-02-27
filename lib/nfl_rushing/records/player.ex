defmodule NflRushing.Records.Player do
  use Ecto.Schema
  import Ecto.Changeset

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

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :team, :position, :attempts_per_game, :rushing_attemps, :total_rushing_yards, :rushing_average_yards_per_attempt, :rushing_yards_per_game, :rushing_touchdowns, :longest_rush, :longest_rush_had_a_touchdown?, :rushing_first_downs, :rushing_first_down_percentage, :rushing_20_yards_each, :rushing_40_yards_each, :fumbles])
    |> validate_required([:name, :team, :position, :attempts_per_game, :rushing_attemps, :total_rushing_yards, :rushing_average_yards_per_attempt, :rushing_yards_per_game, :rushing_touchdowns, :longest_rush, :longest_rush_had_a_touchdown?, :rushing_first_downs, :rushing_first_down_percentage, :rushing_20_yards_each, :rushing_40_yards_each, :fumbles])
  end
end
