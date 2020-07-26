defmodule Trigonometry do

  @spec get_angle(number(), number()) :: number()
  def get_angle(distance, height) do
    :math.atan(height / distance)
    |> radians_to_degrees
  end

  @spec radians_to_degrees(number()) :: number()
  defp radians_to_degrees(radians), do: radians * 180/:math.pi
end
