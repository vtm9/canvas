defmodule Canvas.Drawing do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import PolymorphicEmbed, only: [cast_polymorphic_embed: 3]

  alias __MODULE__
  alias Canvas.Repo

  @derive {Jason.Encoder, only: [:id, :type, :image_id, :props]}
  @types ~w(rectangle flood)

  schema "drawings" do
    belongs_to(:image, Canvas.Image)

    field(:type, :string)

    field :props, PolymorphicEmbed,
      types: [
        rectangle: Canvas.Drawing.Rectangle,
        flood: Canvas.Drawing.Flood
      ],
      on_replace: :update

    timestamps()
  end

  def changeset(%Drawing{} = drawing, attrs) do
    drawing
    |> cast(attrs, [:type, :image_id])
    |> validate_required([:image_id, :type])
    |> validate_inclusion(:type, @types)
    |> cast_polymorphic_embed(:props, required: true)
    |> foreign_key_constraint(:image_id, name: :drawings_image_id_fkey)
  end

  def create(attrs) do
    %Drawing{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
