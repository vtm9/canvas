defmodule Canvas.Render do
  @moduledoc false

  alias __MODULE__

  @default_char " "

  @typep points :: %{optional({pos_integer, pos_integer}) => atom}
  @type t :: %Render{points: points, width: pos_integer, height: pos_integer}
  defstruct points: %{}, width: 0, height: 0

  defguardp in_image?(width, height, x, y)
            when x >= 0 and x <= width and y >= 0 and y <= height

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
      render_drawing(acc, drawing)
    end)
  end

  defp render_drawing(
         render,
         %{type: "rectangle", props: %{outline: outline, fill: fill}} = drawing
       )
       when outline != nil and fill != nil do
    %{
      props: %{
        corner: [corner_x, corner_y],
        width: width,
        height: height
      }
    } = drawing

    (corner_x + 1)..(corner_x + width - 2)
    |> Enum.reduce(render, fn x, acc ->
      render_column(acc, x, corner_y, corner_y + height - 1, fill)
    end)
    |> render_rectangle_outline(drawing)
  end

  defp render_drawing(
         render,
         %{type: "rectangle", props: %{outline: outline, fill: fill}} = drawing
       )
       when outline != nil and fill == nil do
    render
    |> render_rectangle_outline(drawing)
  end

  defp render_rectangle_outline(render, drawing) do
    %{
      props: %{
        corner: [corner_x, corner_y],
        outline: outline,
        width: width,
        height: height
      }
    } = drawing

    render
    |> render_row(corner_y, corner_x, corner_x + width - 1, outline)
    |> render_row(corner_y + height - 1, corner_x, corner_x + width - 1, outline)
    |> render_column(corner_x, corner_y, corner_y + height - 1, outline)
    |> render_column(corner_x + width - 1, corner_y, corner_y + height - 1, outline)
  end

  defp render_drawing(
         render,
         %{type: "rectangle", props: %{outline: outline, fill: fill}} = drawing
       )
       when outline == nil and fill != nil do
    %{
      props: %{
        corner: [corner_x, corner_y],
        width: width,
        height: height
      }
    } = drawing

    corner_x..(corner_x + width - 1)
    |> Enum.reduce(render, fn x, acc ->
      render_column(acc, x, corner_y, corner_y + height - 1, fill)
    end)
  end

  defp render_drawing(render, %{type: "flood"} = flood) do
    render
  end

  def render_row(render, y, from_x, to_x, char) do
    from_x..to_x
    |> Enum.reduce(render, fn x, acc -> render_point(acc, {x, y}, char) end)
  end

  def render_column(render, x, from_y, to_y, char) do
    from_y..to_y
    |> Enum.reduce(render, fn y, acc -> render_point(acc, {x, y}, char) end)
  end

  def render_point(%{width: width, height: height, points: points} = render, {x, y}, char)
      when in_image?(width, height, x, y) do
    %{render | points: Map.put(points, {x, y}, char)}
  end

  def render_point(render, _point, _char), do: render

  defp print(render) do
    %Render{width: width, height: height} = render

    Enum.reduce(0..height, "", fn row_num, acc ->
      row =
        Enum.reduce(0..width, acc, fn col_num, col_acc ->
          col_acc <> Map.get(render.points, {col_num, row_num}, @default_char)
        end)

      if row_num == height do
        row
      else
        row <> "\n"
      end
    end)
  end
end
