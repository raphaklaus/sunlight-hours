# SunlightHours

![Elixir CI](https://github.com/raphaklaus/sunlight-hours/workflows/Elixir%20CI/badge.svg)

Find out how much a neighborhood receives of sunlight.

To run that you must have Elixir and Erlang installed.

## How to use it

```bash
  $ iex -S mix
```

When inside the project's REPL:

```elixir
  # To init the server with some state
  {:ok, pid} =
    GenServer.start_link(SunlightHours, [
      %{
        neighborhood_name: "01",
        apartment_height: 1,
        buildings: [
          %{
            building_name: "Building 1",
            apartment_count: 1,
            distance: 1
          }
        ]
      }
    ])

  # To get the hours of sunlight
  GenServer.call(pid,
    {:get,
    %{
      neighborhood_name: "02",
      building_name: "Building 99",
      apartment_number: 0
    }}
  )
```

## Testing

```bash
  $ mix test
```

## Coverage

```bash
  $ mix coveralls
```
