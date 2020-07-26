defmodule SunlightHoursTest do
  use ExUnit.Case
  doctest SunlightHours

  test "given neighborhood, calculate sunlight hour for each building's apartment" do
    assert SunlightHours.calc(
             %{
               apartment_height: 1,
               buildings: [
                 %{
                   name: "Building 1",
                   apartment_count: 5,
                   distance: 1
                 }
               ]
             },
             %{
               name: "Building 1",
               apartament_number: 0
             }
           ) === "08:14:00 - 17:25:00"
  end
end
