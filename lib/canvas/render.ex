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

  defp render_drawing(render, %{type: "flood"} = drawing) do
    %{props: %{char: char, point: [point_x, point_y]}} = drawing

    visited = MapSet.new()
    original_char = get_char(render, {point_x, point_y})

    {new_render, _visited} =
      render_flood(render, visited, {point_x, point_y}, original_char, char)

    new_render
  end

  defp render_flood(
         %{width: width, height: height} = render,
         visited,
         {point_x, point_y},
         original_char,
         char
       )
       when in_image?(width, height, point_x, point_y) do
    if get_char(render, {point_x, point_y}) != original_char do
      {render, visited}
    else
      new_visited = MapSet.put(visited, {point_x, point_y})
      new_render = render_point(render, {point_x, point_y}, char)

      nearby_points =
        [
          {point_x - 1, point_y},
          {point_x + 1, point_y},
          {point_x, point_y - 1},
          {point_x, point_y + 1}
        ]
        |> Enum.filter(&(!MapSet.member?(new_visited, &1)))
        |> Enum.filter(fn {x, y} -> in_image?(width, height, x, y) end)

      Enum.reduce(nearby_points, {new_render, new_visited}, fn {next_x, next_y},
                                                               {acc_render, acc_visited} ->
        render_flood(acc_render, acc_visited, {next_x, next_y}, original_char, char)
      end)
    end
  end

  defp render_flood(render, visited, _point, _original_char, _char), do: {render, visited}

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

  defp render_row(render, y, from_x, to_x, char) do
    from_x..to_x
    |> Enum.reduce(render, fn x, acc -> render_point(acc, {x, y}, char) end)
  end

  defp render_column(render, x, from_y, to_y, char) do
    from_y..to_y
    |> Enum.reduce(render, fn y, acc -> render_point(acc, {x, y}, char) end)
  end

  defp render_point(%{width: width, height: height, points: points} = render, {x, y}, char)
       when in_image?(width, height, x, y) do
    %{render | points: Map.put(points, {x, y}, char)}
  end

  defp render_point(render, _point, _char), do: render

  defp print(render) do
    %Render{width: width, height: height} = render

    Enum.reduce(0..height, "", fn row_num, acc ->
      row =
        Enum.reduce(0..width, acc, fn col_num, col_acc ->
          col_acc <> get_char(render, {col_num, row_num})
        end)

      if row_num == height do
        row
      else
        row <> "\n"
      end
    end)
  end

  defp get_char(render, point) do
    Map.get(render.points, point, @default_char)
  end
end
