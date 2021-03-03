defmodule NflRushing.Data.PlayerEncoder do
  alias NflRushing.Records.Player
  alias NflRushing.Data.Encoder

  @behaviour Encoder

  @impl Encoder
  def encode(player = %Player{}) do
    touchdown_identifier = if player.longest_rush_had_a_touchdown?, do: "T", else: ""
    longest_rush_with_touchdown = "#{player.longest_rush}" <> touchdown_identifier

    %{
      "Player" => player.name,
      "Team" => player.team,
      "Pos" => player.position,
      "Att/G" => player.attempts_per_game,
      "Att" => player.rushing_attemps,
      "Yds" => player.total_rushing_yards,
      "Avg" => player.rushing_average_yards_per_attempt,
      "Yds/G" => player.rushing_yards_per_game,
      "TD" => player.rushing_touchdowns,
      "Lng" => longest_rush_with_touchdown,
      "1st" => player.rushing_first_downs,
      "1st%" => player.rushing_first_down_percentage,
      "20+" => player.rushing_20_yards_each,
      "40+" => player.rushing_40_yards_each,
      "FUM" => player.fumbles
    }
  end
end
