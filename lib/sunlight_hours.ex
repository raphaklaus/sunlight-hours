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
    |> Enum.with_index()
    |> Enum.find(fn {x, _} -> x.name === query.name end)
    |> case do
      nil ->
        :error

      current_building_with_index ->
        calc_direction(neighborghood, current_building_with_index, {})
    end
  end

  defp calc_direction(neighborghood, current_building_with_index, result, start_direction \\ :right) do
    {building_found, building_index} = current_building_with_index

    neighborghood.buildings
    |> slice_array(start_direction, building_index, length(neighborghood.buildings))
    |> Enum.map(&calc_angle(
      start_direction,
      calc_width(start_direction, &1, building_found),
      neighborghood.apartment_height * &1.apartment_count
    ))
    |> check_for_fallback_angle(start_direction)
    |> case do
      angles when start_direction === :left ->
        Tuple.append(result, Enum.max(angles))

      angles ->
        calc_direction(neighborghood, current_building_with_index,
          Tuple.append(result, Enum.max(angles)),
          :left
        )
    end
  end

  defp check_for_fallback_angle([], start_direction), do: [cast_no_shadow(start_direction)]
  defp check_for_fallback_angle(angles, _start_direction), do: angles

  defp slice_array(buildings, :right, building_index, building_length) do
    Enum.slice(buildings, building_index + 1, building_length)
  end

  defp slice_array(buildings, :left, building_index, _building_length) do
    Enum.slice(buildings, 0, building_index)
  end

  defp cast_no_shadow(:right), do: 0.0
  defp cast_no_shadow(:left), do: 180.0

  defp calc_width(:right, nearby_building, building_found) do
    nearby_building.distance - building_found.distance
  end

  defp calc_width(:left, nearby_building, building_found) do
    building_found.distance - nearby_building.distance
  end

  defp calc_angle(:left, width, height) do
    180.0 - Trigonometry.get_angle(width, height)
  end

  defp calc_angle(:right, width, height) do
    Trigonometry.get_angle(width, height)
  end
end
