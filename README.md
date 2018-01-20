# Pricezilla

**TODO: Add description**

## Installation

Setup libraries:
`mix deps.get`
`mix deps.compile`

Create .env file with the keys:
export OMEGA_PRICING_API_KEY=
export OMEGA_PRICING_API_URL=

After creating load the .env
`source .env`

Setup database:
`mix ecto.create`
`mix ecto.migrate`

Run the tests
`mix test`

Start the application
`elixir app_name`

```elixir
def deps do
  [
    {:pricezilla, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/pricezilla](https://hexdocs.pm/pricezilla).

