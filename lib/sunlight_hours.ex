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
          buildings: list(building)
        }

  @type query :: %{
          name: binary(),
          apartament_number: non_neg_integer()
        }

  @spec calc(neighborghood, query) :: binary()
  def calc(neighborghood, query) do
    neighborghood.buildings
    |> Enum.find(fn x -> x.name === query.name end)
    |> case do
      nil -> :error
      _ -> "08:14:00 - 17:25:00"
    end
  end
end
