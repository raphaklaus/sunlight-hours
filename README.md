# SunlightHours

Find out how much a neighborhood receives of sunlight.

To run that you must have Elixir and Erlang installed.

## How to use it

```bash
  $ iex -S mix
  iex > SunlightHours.calc(%{
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
        })
```

## Testing

```bash
  $ mix test
```

## Coverage

```bash
  $ mix coveralls
```
