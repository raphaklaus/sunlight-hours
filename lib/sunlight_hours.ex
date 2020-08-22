defmodule SunlightHours do
  use GenServer

  @moduledoc """
    Documentation for SunlightHours.
  """

  @type building :: %{
          name: binary(),
          apartment_count: non_neg_integer(),
          distance: non_neg_integer()
        }

  @type neighborhood :: %{
          neighborhood_name: binary(),
          apartment_height: non_neg_integer(),
          buildings: [building()]
        }

  @type query :: %{
          building_name: binary(),
          neighborhood_name: binary(),
          apartment_number: non_neg_integer()
        }

  @null_map %{buildings: []}

  def init(neighborhoods) do
    {:ok, neighborhoods}
  end

  def handle_call({:calc, query}, _from, state) do
    {:reply, calc(state, query), state}
  end

  @spec calc([neighborhood], query) :: tuple()
  def calc(neighborhoods, query) do
    current_neighborhood =
      neighborhoods
      |> Enum.find(@null_map, fn x -> x.neighborhood_name === query.neighborhood_name end)

    current_neighborhood.buildings
    |> Enum.with_index()
    |> Enum.find(fn {x, _} -> x.building_name === query.building_name end)
    |> case do
      nil ->
        :error

      current_building_with_index ->
        calc_direction(query, current_neighborhood, current_building_with_index, {})
        |> Utils.angles_to_hours()
    end
  end

  defp calc_direction(
         query,
         neighborhood,
         current_building_with_index,
         result,
         start_direction \\ :right
       ) do
    {queried_building, building_index} = current_building_with_index

    neighborhood.buildings
    |> slice_array(start_direction, building_index, length(neighborhood.buildings))
    |> Enum.map(
      &calc_angle(
        start_direction,
        calc_width(start_direction, &1, queried_building),
        neighborhood.apartment_height * &1.apartment_count -
          query.apartment_number * neighborhood.apartment_height
      )
    )
    |> Enum.map(&max(0.0, &1))
    |> check_for_fallback_angle(start_direction)
    |> case do
      angles when start_direction === :left ->
        Tuple.append(result, Enum.max(angles))

      angles ->
        calc_direction(
          query,
          neighborhood,
          current_building_with_index,
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

  defp calc_width(:right, nearby_building, queried_building) do
    nearby_building.distance - queried_building.distance
  end

  defp calc_width(:left, nearby_building, queried_building) do
    queried_building.distance - nearby_building.distance
  end

  defp calc_angle(:left, width, height) do
    180.0 - Trigonometry.get_angle(width, height)
  end

  defp calc_angle(:right, width, height) do
    Trigonometry.get_angle(width, height)
  end
end
