defmodule Canvas.Render do
  @moduledoc false

  alias Canvas.Render

  @default_char " "

  @typep points :: %{optional({pos_integer, pos_integer}) => atom}
  @type t :: %Render{points: points, width: pos_integer, height: pos_integer}
  defstruct points: %{}, width: 0, height: 0

  def call(image) do
    %{drawings: drawings, width: width, height: height} = image

    render = %Render{width: width, height: height}

    canvas =
      render
      |> render_drawings(drawings)
      |> print()

    Map.put(image, :canvas, canvas)
  end

  defp render_drawings(render, drawings) do
    Enum.reduce(drawings, render, fn drawing, acc ->
      case drawing do
        %{type: "rectangle"} -> render_rectangle(acc, drawing)
        %{type: "flood"} -> render_flood(acc, drawing)
      end
    end)
  end

  defp render_rectangle(render, rectangle) do
    render
  end

  defp render_flood(render, flood) do
    render
  end

  defp print(render) do
    %Render{width: width, height: height} = render

    Enum.reduce(1..height, "", fn row_num, acc ->
      row =
        Enum.reduce(1..width, acc, fn col_num, col_acc ->
          col_acc <> Map.get(render, {row_num, col_num}, @default_char)
        end)

      if row_num == height do
        row
      else
        row <> "\n"
      end
    end)
  end
end
