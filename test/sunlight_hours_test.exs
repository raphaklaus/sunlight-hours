defmodule SunlightHoursTest do
  use ExUnit.Case
  doctest SunlightHours

  test "1 building, should get sunlight all day" do
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
               apartment_number: 0
             }
           ) === {0, 180}
  end

  test "2 building, the queried is behind another, should get partial sunlight" do
    assert SunlightHours.calc(
             %{
               apartment_height: 1,
               buildings: [
                 %{
                   name: "Building 1",
                   apartment_count: 1,
                   distance: 1
                 },
                 %{
                   name: "Building 2",
                   apartment_count: 1,
                   distance: 1
                 }
               ]
             },
             %{
               name: "Building 1",
               apartment_number: 0
             }
           ) === {:non_zero, 180}
  end

  test "3 building, the queried is in between, should get partial sunlight" do
    assert SunlightHours.calc(
             %{
               apartment_height: 1,
               buildings: [
                 %{
                   name: "Building 1",
                   apartment_count: 1,
                   distance: 1
                 },
                 %{
                   name: "Building 2",
                   apartment_count: 1,
                   distance: 1
                 },
                 %{
                   name: "Building 3",
                   apartment_count: 1,
                   distance: 1
                 }
               ]
             },
             %{
               name: "Building 2",
               apartment_number: 0
             }
           ) === {45.0, :non_zero}
  end
end
