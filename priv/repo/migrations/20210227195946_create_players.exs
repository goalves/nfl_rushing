defmodule NflRushing.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :team, :string
      add :position, :string
      add :attempts_per_game, :float
      add :rushing_attemps, :integer
      add :total_rushing_yards, :float
      add :rushing_average_yards_per_attempt, :float
      add :rushing_yards_per_game, :float
      add :rushing_touchdowns, :integer
      add :longest_rush, :integer
      add :longest_rush_had_a_touchdown?, :boolean, default: false, null: false
      add :rushing_first_downs, :integer
      add :rushing_first_down_percentage, :float
      add :rushing_20_yards_each, :integer
      add :rushing_40_yards_each, :integer
      add :fumbles, :integer

      timestamps()
    end

  end
end
