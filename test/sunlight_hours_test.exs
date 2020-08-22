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
           ) === {"08:14", "17:25"}
  end

  test "2 buildings, the queried is behind another, should get partial sunlight" do
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
                   distance: 2
                 }
               ]
             },
             %{
               name: "Building 1",
               apartment_number: 0
             }
           ) === {"10:31", "17:25"}
  end

  test "2 buildings, the queried is behind another, using apartment_number, should get partial sunlight" do
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
                   apartment_count: 2,
                   distance: 2
                 }
               ]
             },
             %{
               name: "Building 1",
               apartment_number: 1
             }
           ) === {"10:31", "17:25"}
  end

  test "2 buildings, the queried is taller, using apartment_number, should get sunlight all day" do
    assert SunlightHours.calc(
             %{
               apartment_height: 1,
               buildings: [
                 %{
                   name: "Building 1",
                   apartment_count: 3,
                   distance: 1
                 },
                 %{
                   name: "Building 2",
                   apartment_count: 2,
                   distance: 2
                 }
               ]
             },
             %{
               name: "Building 1",
               apartment_number: 3
             }
           ) === {"08:14", "17:25"}
  end

  test "2 buildings, the queried is behind another bigger one, should get partial sunlight" do
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
                   apartment_count: 2,
                   distance: 2
                 }
               ]
             },
             %{
               name: "Building 1",
               apartment_number: 0
             }
           ) === {"11:28", "17:25"}
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
                   distance: 2
                 },
                 %{
                   name: "Building 3",
                   apartment_count: 2,
                   distance: 3
                 }
               ]
             },
             %{
               name: "Building 2",
               apartment_number: 0
             }
           ) === {"11:28", "15:07"}
  end

  test "4 buildings, the queried is in the far-left and there is a big one next to it, should get partial sunlight" do
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
                   apartment_count: 2.5,
                   distance: 2
                 },
                 %{
                   name: "Building 3",
                   apartment_count: 3,
                   distance: 3
                 },
                 %{
                   name: "Building 4",
                   apartment_count: 1,
                   distance: 4
                 }
               ]
             },
             %{
               name: "Building 1",
               apartment_number: 0
             }
           ) === {"11:42", "17:25"}
  end

  test "3 buildings, but queried none of them, should return an error atom" do
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
                   distance: 2
                 },
                 %{
                   name: "Building 3",
                   apartment_count: 2,
                   distance: 3
                 }
               ]
             },
             %{
               name: "Building 99",
               apartment_number: 0
             }
           ) === :error
  end
end
