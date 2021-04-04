defmodule Canvas.Drawing.Flood do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  @derive {Jason.Encoder, only: [:point, :char]}

  embedded_schema do
    field :point, {:array, :integer}
    field :char, :string
  end

  def changeset(rectangle, attrs) do
    rectangle
    |> cast(attrs, [:point, :char])
    |> validate_required([:point, :char])
  end
end
