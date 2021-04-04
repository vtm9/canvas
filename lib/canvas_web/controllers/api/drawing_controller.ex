defmodule CanvasWeb.Api.DrawingController do
  use CanvasWeb, :controller

  alias Canvas.Drawing

  action_fallback CanvasWeb.Api.FallbackController

  def create(conn, params) do
    with attrs <- drawing_arrts(params),
         {:ok, drawing} <- Drawing.create(attrs) do
      conn
      |> put_status(:created)
      |> json(drawing)
    end
  end

  def drawing_arrts(params) do
    case params do
      %{"drawing" => %{"type" => type, "props" => props} = attrs, "image_id" => image_id} ->
        attrs
        |> Map.put("image_id", image_id)
        |> Map.put("props", Map.put(props, "__type__", type))
    end
  end
end
