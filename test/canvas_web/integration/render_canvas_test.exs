defmodule CanvasWeb.IntegrationRenderCanvasTest do
  use CanvasWeb.ConnCase

  test "renders canvas", %{conn: conn} do
    conn =
      post(conn, Routes.image_path(conn, :create), %{
        image: %{
          width: 20,
          height: 7
        }
      })

    %{"id" => image_id} = json_response(conn, 201)

    post(
      conn,
      Routes.image_drawing_path(conn, :create, image_id),
      %{
        drawing: %{
          type: "rectangle",
          props: %{
            corner: [14, 0],
            width: 7,
            height: 6,
            outline: nil,
            fill: "."
          }
        }
      }
    )

    post(
      conn,
      Routes.image_drawing_path(conn, :create, image_id),
      %{
        drawing: %{
          type: "rectangle",
          props: %{
            corner: [0, 3],
            width: 8,
            height: 4,
            outline: "O",
            fill: nil
          }
        }
      }
    )

    post(
      conn,
      Routes.image_drawing_path(conn, :create, image_id),
      %{
        drawing: %{
          type: "rectangle",
          props: %{
            corner: [5, 5],
            width: 5,
            height: 3,
            outline: "X",
            fill: "X"
          }
        }
      }
    )

    post(
      conn,
      Routes.image_drawing_path(conn, :create, image_id),
      %{
        drawing: %{
          type: "flood",
          props: %{
            point: [0, 0],
            char: "-"
          }
        }
      }
    )

    conn = get(conn, Routes.image_path(conn, :show, image_id))

    assert %{
             "canvas" =>
               "--------------.......\n--------------.......\n--------------.......\nOOOOOOOO------.......\nO      O------.......\nO    XXXXX----.......\nOOOOOXXXXX-----------\n     XXXXX-----------",
             "drawings" => [
               %{
                 "id" => _,
                 "image_id" => ^image_id,
                 "props" => %{
                   "corner" => [14, 0],
                   "fill" => ".",
                   "height" => 6,
                   "outline" => nil,
                   "width" => 7
                 },
                 "type" => "rectangle"
               },
               %{
                 "id" => _,
                 "image_id" => ^image_id,
                 "props" => %{
                   "corner" => [0, 3],
                   "fill" => nil,
                   "height" => 4,
                   "outline" => "O",
                   "width" => 8
                 },
                 "type" => "rectangle"
               },
               %{
                 "id" => _,
                 "image_id" => ^image_id,
                 "props" => %{
                   "corner" => [5, 5],
                   "fill" => "X",
                   "height" => 3,
                   "outline" => "X",
                   "width" => 5
                 },
                 "type" => "rectangle"
               },
               %{
                 "id" => _,
                 "image_id" => ^image_id,
                 "props" => %{"char" => "-", "point" => [0, 0]},
                 "type" => "flood"
               }
             ],
             "height" => 7,
             "id" => ^image_id,
             "width" => 20
           } = json_response(conn, 200)
  end
end
