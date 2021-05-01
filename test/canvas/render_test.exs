defmodule Canvas.RenderTest do
  use Canvas.DataCase

  alias Canvas.Render

  describe ".call/1 valid cases" do
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

      image = build(:image, width: 23, height: 8, drawings: [rec1, rec2])

      expected =
        ~s(
                        \N
                        \N
   @@@@@                \N
   @XXX@  XXXXXXXXXXXXXX\N
   @@@@@  XOOOOOOOOOOOOX\N
          XOOOOOOOOOOOOX\N
          XOOOOOOOOOOOOX\N
          XOOOOOOOOOOOOX\N
          XXXXXXXXXXXXXX\N)
        |> prepare_fixture()

      assert %{canvas: ^expected} = Render.call(image)
    end

    test "renders second fixture image" do
      rec1 =
        build(:rectangle,
          props: %{
            corner: [14, 0],
            width: 7,
            height: 6,
            outline: nil,
            fill: "."
          }
        )

      rec2 =
        build(:rectangle,
          props: %{
            corner: [0, 3],
            width: 8,
            height: 4,
            outline: "O",
            fill: nil
          }
        )

      rec3 =
        build(:rectangle,
          props: %{
            corner: [5, 5],
            width: 5,
            height: 3,
            outline: "X",
            fill: "X"
          }
        )

      image = build(:image, width: 20, height: 7, drawings: [rec1, rec2, rec3])

      expected =
        ~s(
              .......\N
              .......\N
              .......\N
OOOOOOOO      .......\N
O      O      .......\N
O    XXXXX    .......\N
OOOOOXXXXX           \N
     XXXXX           \N)
        |> prepare_fixture()

      assert %{canvas: ^expected} = Render.call(image)
    end

    test "renders third fixture image" do
      rec1 =
        build(:rectangle,
          props: %{
            corner: [14, 0],
            width: 7,
            height: 6,
            outline: nil,
            fill: "."
          }
        )

      rec2 =
        build(:rectangle,
          props: %{
            corner: [0, 3],
            width: 8,
            height: 4,
            outline: "O",
            fill: nil
          }
        )

      rec3 =
        build(:rectangle,
          props: %{
            corner: [5, 5],
            width: 5,
            height: 3,
            outline: "X",
            fill: "X"
          }
        )

      flood =
        build(:flood,
          props: %{
            point: [0, 0],
            char: "-"
          }
        )

      image = build(:image, width: 20, height: 7, drawings: [rec1, rec2, rec3, flood])

      expected =
        ~s(
--------------.......\N
--------------.......\N
--------------.......\N
OOOOOOOO------.......\N
O      O------.......\N
O    XXXXX----.......\N
OOOOOXXXXX-----------\N
     XXXXX-----------\N)
        |> prepare_fixture()

      assert %{canvas: ^expected} = Render.call(image)
    end
  end

  describe ".call/1 invalid cases" do
    test "renders rectangle and flood out of range" do
      rec1 =
        build(:rectangle,
          props: %{
            corner: [5, 5],
            width: 3,
            height: 3,
            fill: "A",
            outline: "B"
          }
        )

      rec2 =
        build(:rectangle,
          props: %{
            corner: [-10, -10],
            width: 2,
            height: 4,
            fill: "C",
            outline: "D"
          }
        )

      rec3 =
        build(:rectangle,
          props: %{
            corner: [2, 2],
            width: 10,
            height: 10,
            fill: "E",
            outline: "F"
          }
        )

      flood1 =
        build(:flood,
          props: %{
            point: [-1, 0],
            char: "-"
          }
        )

      flood2 =
        build(:flood,
          props: %{
            point: [10, 10],
            char: "."
          }
        )

      image = build(:image, width: 4, height: 4, drawings: [rec1, rec2, rec3, flood1, flood2])

      expected =
        ~s(
     \N
     \N
  FFF\N
  FEE\N
  FEE\N)
        |> prepare_fixture()

      assert %{canvas: ^expected} = Render.call(image)
    end
  end

  defp prepare_fixture(text) do
    text
    |> String.replace("\N", "")
    |> String.replace("\n", "", global: false)
  end
end
