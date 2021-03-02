defmodule NflRushing.Query.FilteringParams do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset

  @type t :: %__MODULE__{}

  @required_fields [:contains_string_filter, :field]
  @fields @required_fields

  @primary_key false
  embedded_schema do
    field :contains_string_filter, :string
    field :field, :string
  end

  @spec new(map(), list()) :: {:ok, t()} | {:error, Changeset.t()}
  def new(attributes, acceptable_fields) when is_map(attributes) and is_list(acceptable_fields) do
    %__MODULE__{}
    |> cast(attributes, @fields)
    |> validate_required(@required_fields)
    |> case do
      changeset = %Changeset{valid?: true} -> changeset |> apply_changes() |> build_struct(acceptable_fields)
      changeset = %Changeset{valid?: false} -> {:error, changeset}
    end
  end

  defp build_struct(base = %__MODULE__{}, acceptable_fields) when is_list(acceptable_fields) do
    if acceptable_fields |> Enum.map(&Atom.to_string/1) |> Enum.member?(base.field) do
      field_atom = String.to_existing_atom(base.field)
      struct = Map.put(base, :field, field_atom)
      {:ok, struct}
    else
      {:error, :invalid_field_being_converted}
    end
  end
end
