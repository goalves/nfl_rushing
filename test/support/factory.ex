defmodule NflRushing.Factory do
  use ExMachina.Ecto, repo: NflRushing.Repo

  alias NflRushing.Records.Player

  @max_random_value 50

  def player_factory do
    %Player{
      attempts_per_game: random_float(),
      fumbles: random_integer(),
      longest_rush: random_integer(),
      longest_rush_had_a_touchdown?: random_boolean(),
      name: Faker.Person.first_name(),
      position: "RB",
      rushing_20_yards_each: random_integer(),
      rushing_40_yards_each: random_integer(),
      rushing_attemps: random_integer(),
      rushing_average_yards_per_attempt: random_float(),
      rushing_first_down_percentage: random_float(),
      rushing_first_downs: random_integer(),
      rushing_touchdowns: random_integer(),
      rushing_yards_per_game: random_float(),
      team: Faker.Company.suffix(),
      total_rushing_yards: random_float()
    }
  end

  def importable_data_factory do
    %{
      "Player" => Faker.Person.first_name(),
      "Team" => "GB",
      "Pos" => "RB",
      "Att" => 10,
      "Att/G" => 3.3,
      "Yds" => 32,
      "Avg" => 3.2,
      "Yds/G" => 10.7,
      "TD" => 0,
      "Lng" => "7",
      "1st" => 1,
      "1st%" => 10,
      "20+" => 0,
      "40+" => 0,
      "FUM" => 0
    }
  end

  def random_float(from \\ 0, up_to \\ @max_random_value),
    do: (from + :rand.uniform() * (up_to - from)) |> Float.round(2)

  def random_integer(from \\ 0, up_to \\ @max_random_value),
    do: Faker.random_between(from, up_to)

  def random_boolean, do: :rand.uniform() < 0.5
end
