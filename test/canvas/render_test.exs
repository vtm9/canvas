defmodule Canvas.RenderTest do
  use Canvas.DataCase

  alias Canvas.Render

  describe ".call/1" do
    test "renders first fixture image" do
      rec1 =
        build(:rectangle,
          props: %{
            corner: [3, 2],
            width: 5,
            height: 3,
            outline: "@",
            fill: "X"
          }
        )

      rec2 =
        build(:rectangle,
          props: %{
            corner: [10, 3],
            width: 14,
            height: 6,
            outline: "X",
            fill: "O"
          }
        )

      image = build(:image, width: 24, height: 9, drawings: [rec1, rec2])
      expected = ~S(


   @@@@@
   @XXX@  XXXXXXXXXXXXXX
   @@@@@  XOOOOOOOOOOOOX
          XOOOOOOOOOOOOX
          XOOOOOOOOOOOOX
          XOOOOOOOOOOOOX
          XXXXXXXXXXXXXX
)

      assert %{canvas: ^expected} = Render.call(image)
    end
  end
end
