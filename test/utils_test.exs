defmodule UtilsTest do
  use ExUnit.Case
  doctest Utils

  test "given some arbitrary angle ranges, it should convert to hour ranges" do
    angle_ranges = [
      {0.0, 180.0},
      {90.0, 180.0},
      {95.6666, 180.0}
    ]

    assert Utils.angle_to_hour(Enum.at(angle_ranges, 0)) === {"08:14", "17:25"}
    assert Utils.angle_to_hour(Enum.at(angle_ranges, 1)) === {"12:49", "17:25"}
    assert Utils.angle_to_hour(Enum.at(angle_ranges, 2)) === {"13:06", "17:25"}
  end
end
