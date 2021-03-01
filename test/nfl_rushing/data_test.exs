defmodule NflRushing.DataTest do
  use NflRushing.DataCase

  import Mox
  import NflRushing.Factory

  alias Ecto.UUID
  alias NflRushing.{Data, Repo}
  alias NflRushing.Records.Player

  defp setup_mocks(attributes) do
    Mox.stub_with(NflRushing.Data.MockLoader, NflRushing.Data.StubLoader)
    attributes
  end

  defp importable_data(attributes) do
    data = params_for(:importable_data)
    Map.put(attributes, :data, data)
  end

  defp random_file_path(attributes) do
    file_path = "some/file/path/#{UUID.generate()}"
    Map.put(attributes, :file_path, file_path)
  end

  setup :verify_on_exit!
  setup :setup_mocks
  setup :importable_data
  setup :random_file_path

  describe "import_from_file/1" do
    test "import players from file", %{data: data, file_path: file_path} do
      NflRushing.Data.MockLoader
      |> expect(:load, fn ^file_path -> {:ok, [data]} end)

      assert Data.import_from_file(file_path) == {:ok, 1}
      assert [%Player{}] = Repo.all(Player)
    end
  end
end
