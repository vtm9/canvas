defmodule Canvas.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Canvas.Repo

  def image_factory do
    %Canvas.Image{width: 3, height: 7}
  end
end
