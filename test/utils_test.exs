defmodule UtilsTest do
  use ExUnit.Case
  doctest Utils

  test "given some arbitrary angle ranges, it should convert to hour ranges" do
    test_data = [
      {{0.0, 180.0}, {"08:14", "17:25"}},
      {{45.0, 180.0}, {"10:31", "17:25"}},
      {{63.43494882292202, 180.0}, {"11:28", "17:25"}},
      {{68.19859051364818, 180.0}, {"11:42", "17:25"}},
      {{90.0, 180.0}, {"12:49", "17:25"}},
      {{95.6666, 180.0}, {"13:06", "17:25"}},
      {{95.6666, 135.0}, {"13:06", "15:07"}},
    ]

    for {angles, hours} <- test_data do
      assert Utils.angles_to_hours(angles) === hours
    end
  end
end
