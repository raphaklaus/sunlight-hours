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
    |> Enum.with_index
    |> Enum.find(fn {x, _} -> x.name === query.name end)
    |> case do
      nil -> :error
      current_building_with_index ->
        {
          calc_direction(neighborghood, current_building_with_index, :right),
          calc_direction(neighborghood, current_building_with_index, :left)
        }
    end
  end

  defp calc_direction(neighborghood, current_building_with_index, direction) do
    {building_found, building_index} = current_building_with_index
    building_length = length(neighborghood.buildings)

    neighborghood.buildings
    |> slice_array(direction, building_index, building_length)
    |> Enum.max_by(fn x -> x.apartment_count end, fn -> :no_shadow end)
    |> case  do
      :no_shadow -> cast_no_shadow(direction)
      biggest_shadow ->
        width = calc_width(direction, biggest_shadow, building_found)
        height = neighborghood.apartment_height * biggest_shadow.apartment_count

        calc_angle(direction, width, height)
    end
  end

  defp slice_array(buildings, :right, building_index, building_length) do
    Enum.slice(buildings, building_index + 1, building_length)
  end

  defp slice_array(buildings, :left, building_index, _building_length) do
    Enum.slice(buildings, 0, building_index)
  end

  defp cast_no_shadow(:right), do: 0.0
  defp cast_no_shadow(:left), do: 180.0

  defp calc_width(:right, biggest_shadow, building_found) do
    biggest_shadow.distance - building_found.distance
  end

  defp calc_width(:left, biggest_shadow, building_found) do
    building_found.distance - biggest_shadow.distance
  end

  defp calc_angle(:left, width, height) do
    180.0 - Trigonometry.get_angle(width, height)
  end

  defp calc_angle(:right, width, height) do
    Trigonometry.get_angle(width, height)
  end
end
