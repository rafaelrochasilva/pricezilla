# Pricezilla

Pricezilla is one of the best choices for tracking products pricing. :)
Product price information is fetched from an external API - Abc Princing,
a **FICTICIOUS** API and Company.

## Installation
Follow the steps bellow to setup the project.

Setup libraries:
`mix deps.get`
`mix deps.compile`

Create .env file with the keys, (since the keys are fake I'm sharing it here)
```
export OMEGA_PRICING_API_KEY="RA8R2-LEBJ2-SACI4X-A3J"
export OMEGA_PRICING_API_URL="https://abcpricing.com/"
```

Load the .env:
`source .env`

Setup database:
`mix ecto.create`
`mix ecto.migrate`

Run the tests
`mix test`

## Start the application
To visualize the price faster it is better to change the config bellow:
```
lib/pricezilla/price_processor.ex:40
Process.send_after(self(), :refresh, :timer.seconds(2))
```
and run:
```
mix run --no-halt
```

## Project deps
The project deps above were used to help me build the project

- dialyxir: Type check

- httpoison: Make http requests

- poison: Parse Json

- timex: Manipulate dates

- logger_file_backend: Log into file

- faker: Create fake data

- postgrex: Database

- ecto: Database wrapper
