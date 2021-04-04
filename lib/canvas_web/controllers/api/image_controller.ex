defmodule CanvasWeb.Api.ImageController do
  use CanvasWeb, :controller

  alias Canvas.Image

  action_fallback CanvasWeb.Api.FallbackController

  def create(conn, params) do
    %{"image" => attrs} = params

    with {:ok, image} <- Image.create(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.image_path(conn, :show, image))
      |> json(image)
    end
  end

  def show(conn, %{"id" => id}) do
    image =
      id
      |> Image.get!()
      |> Image.render_canvas()

    json(conn, image)
  end
end
