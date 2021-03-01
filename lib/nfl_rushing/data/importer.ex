defmodule NflRushing.Data.Importer do
  @moduledoc """
  Module responsible for importing contents of a stream containting players data to the database.
  """

  require Logger

  alias NflRushing.Data.Parser
  alias NflRushing.Records.Player
  alias NflRushing.{Records, Repo}

  @insert_per_attempt 500

  @spec run(list(), keyword()) :: {:ok, [Player.t()]} | {:error, any()}
  def run(data, opts \\ []) when is_list(data) do
    skip_invalid_entries? = Keyword.get(opts, :skip_invalid_entries?, false)
    number_of_elements_to_process = Enum.count(data)

    Logger.debug("Processing #{number_of_elements_to_process} elements.")

    data
    |> Flow.from_enumerable()
    |> Flow.map(&Parser.parse_record/1)
    |> Enum.to_list()
    |> Enum.reduce(%{success: [], failure: []}, fn
      {:ok, value}, acc -> %{acc | success: [value | acc.success]}
      {:error, value}, acc -> %{acc | failure: [value | acc.failure]}
    end)
    |> process_results(skip_invalid_entries?)
  end

  defp process_results(%{success: players}, true), do: persist_import(players)
  defp process_results(%{failure: [], success: players}, _), do: persist_import(players)

  defp process_results(%{failure: failed_elements, success: records}, _) do
    number_of_failed_elements = Enum.count(failed_elements)
    number_of_successful_records = Enum.count(records)

    Logger.error(
      "Failed to process #{number_of_failed_elements} and successfully processed #{number_of_successful_records} on importer. Elements will not be persisted on the database."
    )

    {:error, failed_elements}
  end

  defp persist_import(players) when is_list(players) do
    number_of_parsed_elements = Enum.count(players)
    Logger.debug("Parsed all #{number_of_parsed_elements} players successfully.")

    Repo.transaction(fn ->
      players
      |> Stream.chunk_every(@insert_per_attempt)
      |> Stream.map(&Records.insert_players/1)
      |> Enum.to_list()
    end)
    |> case do
      {:ok, [result]} -> result
      error -> error
    end
  end
end
