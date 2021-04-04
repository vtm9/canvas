defmodule Canvas.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Canvas.Repo

  def image_factory do
    %Canvas.Image{width: 3, height: 7, drawings: []}
  end

  def drawing_factory do
    %Canvas.Drawing{props: %{}}
  end

  # derived factory
  def rectangle_factory do
    struct!(
      drawing_factory(),
      %{
        type: "rectangle",
        props: %{
          corner: [1, 1],
          width: 10,
          height: 15
        }
      }
    )
  end

  def flood_factory do
    struct!(
      drawing_factory(),
      %{
        type: "flood",
        props: %{
          point: [1, 2],
          char: "A"
        }
      }
    )
  end
end
