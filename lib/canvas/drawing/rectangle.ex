defmodule Canvas.Drawing.Rectangle do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  @derive {Jason.Encoder, only: [:corner, :width, :height, :fill, :outline]}

  embedded_schema do
    field :corner, {:array, :integer}
    field :width, :integer
    field :height, :integer
    field :fill, :string
    field :outline, :string
  end

  def changeset(rectangle, attrs) do
    rectangle
    |> cast(attrs, [:corner, :width, :height, :fill, :outline])
    |> validate_required([:corner, :width, :height])
    |> validate_fill_or_outline_present()
  end

  defp validate_fill_or_outline_present(%Ecto.Changeset{} = changeset) do
    value = Map.get(changeset.changes, :fill) || Map.get(changeset.changes, :outline)

    case value do
      nil -> add_error(changeset, :base, "fill or outline should always be present")
      _ -> changeset
    end
  end
end
