defmodule TrigonometryTest do
  use ExUnit.Case
  doctest Trigonometry

  test "given distance and height, return angle" do
    assert Trigonometry.get_angle(1, 1) === 45.0
    assert Trigonometry.get_angle(2, 1) |> :math.ceil === 27.0
    assert Trigonometry.get_angle(1, 2) |> :math.ceil === 64.0
  end
end
