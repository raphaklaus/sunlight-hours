defmodule Utils do
  @starting_base_minutes 14 + 8 * 60
  @ending_base_minutes 11 + 540

  @type angle_tuple :: {
          number(),
          number()
        }

  @type hour_tuple :: {
          binary(),
          binary()
        }

  @spec angles_to_hours(angle_tuple()) :: hour_tuple()
  def angles_to_hours(angles) do
    {starting, ending} = angles

    starting_in_minutes = @starting_base_minutes + starting * @ending_base_minutes / 180
    ending_in_minutes = @starting_base_minutes + ending * @ending_base_minutes / 180

    {minutes_to_hours(starting_in_minutes), minutes_to_hours(ending_in_minutes)}
  end

  defp minutes_to_hours(minutes) do
    hours_part =
      :math.floor(minutes / 60) |> trunc |> Integer.to_string() |> String.pad_leading(2, "0")

    minutes_part =
      :math.fmod(minutes, 60) |> trunc |> Integer.to_string() |> String.pad_leading(2, "0")

    "#{hours_part}:#{minutes_part}"
  end
end
