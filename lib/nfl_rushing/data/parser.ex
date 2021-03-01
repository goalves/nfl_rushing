defmodule NflRushing.Data.Parser do
  require Logger
  alias NflRushing.Records.Player

  def parse_record(data) when is_map(data) do
    with {:ok, parsed_data} when is_map(parsed_data) <- parse_data(data),
         {:ok, player = %Player{}} <- Player.new(parsed_data) do
      {:ok, player}
    else
      error ->
        Logger.warn("Failed to parse element: #{inspect(error)}")

        error
    end
  end

  def parse_record(_), do: {:error, :invalid_data}

  defp parse_data(data) when is_map(data) do
    with {:ok, {longest_rush, has_touchdown?}} <- parse_longest_rush(data["Lng"]) do
      total_rushing_yards = parse_total_rushing_yards(data["Yds"])
      build_map(data, longest_rush, has_touchdown?, total_rushing_yards)
    end
  end

  defp parse_longest_rush(longest_rush) when is_binary(longest_rush) do
    case Integer.parse(longest_rush) do
      {value, "T"} -> {:ok, {value, true}}
      {value, "t"} -> {:ok, {value, true}}
      {value, _} -> {:ok, {value, false}}
      _ -> {:error, :cannot_parse_longest_rush}
    end
  end

  defp parse_longest_rush(longest_rush), do: {:ok, {longest_rush, false}}

  defp parse_total_rushing_yards(yards) when is_binary(yards), do: String.replace(yards, ",", "")
  defp parse_total_rushing_yards(yards), do: yards

  defp build_map(data, longest_rush, longest_rush_has_touchdown?, total_rushing_yards)
       when is_map(data) and is_boolean(longest_rush_has_touchdown?) do
    {:ok,
     %{
       name: data["Player"],
       team: data["Team"],
       position: data["Pos"],
       attempts_per_game: data["Att/G"],
       rushing_attemps: data["Att"],
       total_rushing_yards: total_rushing_yards,
       rushing_average_yards_per_attempt: data["Avg"],
       rushing_yards_per_game: data["Yds/G"],
       rushing_touchdowns: data["TD"],
       longest_rush: longest_rush,
       longest_rush_had_a_touchdown?: longest_rush_has_touchdown?,
       rushing_first_downs: data["1st"],
       rushing_first_down_percentage: data["1st%"],
       rushing_20_yards_each: data["20+"],
       rushing_40_yards_each: data["40+"],
       fumbles: data["FUM"]
     }}
  end
end
