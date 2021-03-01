defmodule NflRushing.Data.ImporterTest do
  use NflRushing.DataCase

  import ExUnit.CaptureLog
  import NflRushing.Factory

  alias Ecto.Changeset
  alias NflRushing.Data.Importer
  alias NflRushing.Records.Player

  defp importable_data(_) do
    number_of_elements = random_integer(1, 5)
    data = Enum.map(0..number_of_elements, fn _ -> params_for(:importable_data) end)

    %{data: data}
  end

  describe "run/1" do
    setup [:importable_data]

    test "imports data", %{data: data} do
      number_of_elements = Enum.count(data)

      assert Importer.run(data) == {:ok, number_of_elements}
      assert created_players = Repo.all(Player)
      assert is_list(created_players)
      assert Enum.count(created_players) == number_of_elements
    end

    test "imports data skipping invalid entries", %{data: data} do
      number_of_valid_elements = Enum.count(data)
      data_with_invalid_element = [%{} | data]

      assert Importer.run(data_with_invalid_element, skip_invalid_entries?: true) == {:ok, number_of_valid_elements}
    end

    test "logs a debug messages when importing elements", %{data: data} do
      number_of_elements = Enum.count(data)
      importing_function = fn -> Importer.run(data) end

      assert capture_log(importing_function) =~ "Processing #{number_of_elements} elements."
      assert capture_log(importing_function) =~ "Parsed all #{number_of_elements} players successfully."
    end

    test "test returns an error when data is invalid" do
      assert {:error, [%Changeset{}]} = Importer.run([%{}])
    end

    test "logs an error when fails to process elements" do
      importing_function = fn -> Importer.run([%{}]) end

      assert capture_log(importing_function) =~
               "Failed to process 1 and successfully processed 0 on importer"
    end
  end
end
