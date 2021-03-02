defmodule NflRushing.Query.SortingParams do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset

  @type t :: %__MODULE__{}

  @required_fields [:field, :ordering]
  @fields @required_fields
  @valid_ordering ["asc", "desc"]

  @primary_key false
  embedded_schema do
    field :field, :string
    field :ordering, :string, default: :asc
  end

  @spec new(map(), list()) :: {:ok, t()} | {:error, Changeset.t()}
  def new(attributes, acceptable_fields) when is_map(attributes) and is_list(acceptable_fields) do
    %__MODULE__{}
    |> cast(attributes, @fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:ordering, @valid_ordering)
    |> case do
      changeset = %Changeset{valid?: true} -> changeset |> apply_changes() |> build_struct(acceptable_fields)
      changeset = %Changeset{valid?: false} -> {:error, changeset}
    end
  end

  defp build_struct(base = %__MODULE__{}, acceptable_fields) when is_list(acceptable_fields) do
    if acceptable_fields |> Enum.map(&Atom.to_string/1) |> Enum.member?(base.field) do
      struct = %__MODULE__{field: String.to_existing_atom(base.field), ordering: String.to_existing_atom(base.ordering)}
      {:ok, struct}
    else
      {:error, :invalid_field_being_converted}
    end
  end
end
