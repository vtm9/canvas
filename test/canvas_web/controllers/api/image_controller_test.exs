defmodule CanvasWeb.Api.ImageControllerTest do
  use CanvasWeb.ConnCase

  describe "POST /images" do
    test "creates image", %{conn: conn} do
      conn =
        post(conn, Routes.image_path(conn, :create), %{
          image: %{
            width: 3,
            height: 7
          }
        })

      body = json_response(conn, 201)
      assert %{"id" => _id, "width" => 3, "height" => 7, "canvas" => ""} = body
      assert get_req_header(conn, "location")

      assert Canvas.Repo.count(Canvas.Image) == 1
    end

    test "validates image attrs", %{conn: conn} do
      conn =
        post(conn, Routes.image_path(conn, :create), %{
          image: %{
            height: -1
          }
        })

      assert json_response(conn, 422) == %{
               "errors" => %{
                 "height" => ["must be greater than or equal to 0"],
                 "width" => ["can't be blank"]
               }
             }

      assert Canvas.Repo.count(Canvas.Image) == 0
    end
  end

  describe "GET /images/:id" do
    test "renders empty image", %{conn: conn} do
      image = insert(:image, width: 3, height: 2)
      conn = get(conn, Routes.image_path(conn, :show, image.id))

      assert json_response(conn, 200) ==
               %{
                 "id" => image.id,
                 "height" => image.height,
                 "width" => image.width,
                 "drawings" => [],
                 "canvas" => "    \n    \n    "
               }
    end
  end
end
