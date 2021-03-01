defmodule NflRushing.Data.JSONLoaderTest do
  use NflRushing.DataCase

  import ExUnit.CaptureLog

  alias NflRushing.Data.JSONLoader

  defp file_path, do: "#{:code.priv_dir(:nfl_rushing)}/stub_data/rushing.json"

  describe "load/1" do
    test "loads contents of a json file from disk" do
      assert {:ok, list} = file_path() |> JSONLoader.load()
      assert Enum.count(list) == 1
    end

    test "logs a debug message when successfully loads a file" do
      file_path = file_path()
      load_function = fn -> JSONLoader.load(file_path) end

      assert capture_log(load_function) =~ "Successfully loaded file on #{file_path}"
    end

    test "returns an error when file does not exist" do
      assert {:error, :enoent} == JSONLoader.load("invalid/path")
    end
  end
end
