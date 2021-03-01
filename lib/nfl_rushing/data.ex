defmodule NflRushing.Data do
  alias NflRushing.Data.Importer
  alias NflRushing.Records.Player

  @spec import_from_file(binary(), keyword()) :: {:ok, [Player.t()]} | {:error, any()}
  def import_from_file(file_path, opts \\ []) when is_binary(file_path) do
    importer_opts = Keyword.get(opts, :importer_opts, [])

    with {:ok, contents} <- loader().load(file_path),
         do: Importer.run(contents, importer_opts)
  end

  def loader, do: Application.get_env(:nfl_rushing, __MODULE__)[:loader]
end
