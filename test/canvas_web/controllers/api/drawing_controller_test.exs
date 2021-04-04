defmodule CanvasWeb.Api.DrawingControllerTest do
  use CanvasWeb.ConnCase

  describe "POST /drawings SUCCESS" do
    test "creates drawing with rectangle", %{conn: conn} do
      image = insert(:image)

      conn =
        post(
          conn,
          Routes.image_drawing_path(conn, :create, image.id),
          %{
            drawing: %{
              type: "rectangle",
              props: %{
                corner: [1, 2],
                width: 10,
                height: 15,
                fill: "A",
                outline: "B"
              }
            }
          }
        )

      image_id = image.id
      body = json_response(conn, 201)
      created = Canvas.Repo.one(Canvas.Drawing)

      assert %{
               image_id: ^image_id,
               type: "rectangle",
               props: %{
                 corner: [1, 2],
                 fill: "A",
                 height: 15,
                 outline: "B",
                 width: 10
               }
             } = created

      assert body ==
               %{
                 "id" => created.id,
                 "image_id" => image_id,
                 "type" => "rectangle",
                 "props" => %{
                   "corner" => [1, 2],
                   "fill" => "A",
                   "height" => 15,
                   "outline" => "B",
                   "width" => 10
                 }
               }
    end

    test "creates drawing with flood", %{conn: conn} do
      image = insert(:image)

      conn =
        post(
          conn,
          Routes.image_drawing_path(conn, :create, image.id),
          %{
            drawing: %{
              type: "flood",
              props: %{
                point: [1, 2],
                char: "C"
              }
            }
          }
        )

      image_id = image.id
      body = json_response(conn, 201)
      created = Canvas.Repo.one(Canvas.Drawing)

      assert %{
               image_id: ^image_id,
               type: "flood",
               props: %{
                 point: [1, 2],
                 char: "C"
               }
             } = created

      assert body ==
               %{
                 "id" => created.id,
                 "image_id" => image_id,
                 "type" => "flood",
                 "props" => %{
                   "point" => [1, 2],
                   "char" => "C"
                 }
               }
    end
  end

  describe "POST /drawings FAILURE" do
    test "validates image presence", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.image_drawing_path(conn, :create, 123),
          %{
            drawing: %{
              type: "rectangle",
              props: %{
                corner: [1, 2],
                width: 10,
                height: 15,
                fill: "A",
                outline: "B"
              }
            }
          }
        )

      body = json_response(conn, 422)

      assert body == %{"errors" => %{"image_id" => ["does not exist"]}}
    end

    test "validates fill or outline precense in rectangle props", %{conn: conn} do
      image = insert(:image)

      conn =
        post(
          conn,
          Routes.image_drawing_path(conn, :create, image.id),
          %{
            drawing: %{
              type: "rectangle",
              props: %{
                corner: [1, 2],
                width: 10,
                height: 15
              }
            }
          }
        )

      body = json_response(conn, 422)

      assert body == %{
               "errors" => %{"props" => %{"base" => ["fill or outline should always be present"]}}
             }
    end
  end
end
