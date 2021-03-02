defmodule NflRushing.Repo.Migrations.CreateIndexesOnSortedElements do
  use Ecto.Migration

  def change do
    create(index(:players, :name))
    create(index(:players, :total_rushing_yards))
    create(index(:players, :longest_rush))
    create(index(:players, :rushing_touchdowns))
  end
end
