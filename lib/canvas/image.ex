defmodule Canvas.Image do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias __MODULE__
  alias Canvas.Repo

  @derive {Jason.Encoder, only: [:id, :width, :height, :canvas, :drawings]}
  @default_attrs %{"drawings" => []}

  schema "images" do
    has_many(:drawings, Canvas.Drawing)

    field :width, :integer
    field :height, :integer
    field :canvas, :string, virtual: true, default: ""

    timestamps()
  end

  def changeset(%Image{} = image, attrs) do
    image
    |> cast(attrs, [:width, :height])
    |> cast_assoc(:drawings)
    |> validate_required([:width, :height])
    |> validate_number(:width, greater_than_or_equal_to: 0)
    |> validate_number(:height, greater_than_or_equal_to: 0)
  end

  def create(attrs) do
    new_attrs = Map.merge(@default_attrs, attrs)

    %Image{}
    |> changeset(new_attrs)
    |> Repo.insert()
  end

  def render_canvas(image) do
    Canvas.Render.call(image)
  end

  def get!(id) do
    query =
      from image in Image,
        left_join: drawings in assoc(image, :drawings),
        order_by: [asc: drawings.id],
        preload: [drawings: drawings]

    Repo.get!(query, id)
  end
end
