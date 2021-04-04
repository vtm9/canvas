defmodule Canvas.Render do
  @moduledoc false

  @default_char " "

  def call(image) do
    # %{drawings: drawings, width: width, height: height} = image

    canvas =
      image
      |> render_base()
      |> print()

    Map.put(image, :canvas, canvas)
  end

  defp render_base(image) do
    %{width: width, height: height} = image

    @default_char
    |> List.duplicate(width)
    |> List.duplicate(height)
  end

  defp print(struct) do
    struct
    |> Enum.map(fn x -> Enum.join(x) end)
    |> Enum.join("\n")
  end
end
