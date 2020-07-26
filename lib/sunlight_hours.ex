defmodule SunlightHours do
  @moduledoc """
  Documentation for SunlightHours.
  """

  @type building :: %{
          name: binary(),
          apartment_count: non_neg_integer(),
          distance: non_neg_integer()
        }

  @type neighborghood :: %{
          neighborhood: binary(),
          apartment_height: non_neg_integer(),
          buildings: [building()]
        }

  @type query :: %{
          name: binary(),
          apartment_number: non_neg_integer()
        }

  @spec calc(neighborghood, query) :: tuple()
  def calc(neighborghood, query) do
    neighborghood.buildings
    |> Enum.find_index(fn x -> x.name === query.name end)
    |> case do
      nil -> :error
      current_building_index ->
        building_length = length(neighborghood.buildings)
        {min_angle(neighborghood.buildings, current_building_index, neighborghood.apartment_height, query.apartment_number), max_angle(building_length, current_building_index)}
    end
  end

  @spec min_angle([building()], non_neg_integer(), non_neg_integer(), non_neg_integer()) :: number()
  defp min_angle(buildings, current_building_index, _apartment_height, _apartment_number) when current_building_index === length(buildings) - 1 do
    0
  end

  defp min_angle(buildings, current_building_index, apartment_height, apartment_number) do
    width = get_width(buildings, current_building_index)
    height = get_height(apartment_height, apartment_number, current_building_index, buildings)

    IO.inspect "width"
    IO.inspect width
    IO.inspect "height"
    IO.inspect height

    Trigonometry.get_angle(width, height)
    |> IO.inspect
  end

  @spec max_angle(number(), number()) :: number()
  defp max_angle(building_length, building_index)

  defp max_angle(_building_length, 0) do
    180
  end

  defp max_angle(_building_length, _building_index) do
    :non_zero # TODO: do the proper calculation here
  end

  @spec get_height(number(), number(), non_neg_integer(), [building()]) :: number
  defp get_height(apartment_height, apartment_number, current_building_index, buildings) do
    current_apartment_height = apartment_height + apartment_number
    building = Enum.at(buildings, current_building_index + 1)

    next_building_height = building.apartment_count * apartment_height

    next_building_height - current_apartment_height
  end

  @spec get_width([building()], number()) :: number()
  defp get_width(buildings, current_building_index) do
    Enum.at(buildings, current_building_index + 1) # cautious with this operation!
    |> Map.get(:distance)
  end
end
