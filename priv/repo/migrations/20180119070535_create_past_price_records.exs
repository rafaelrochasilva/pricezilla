defmodule Pricezilla.Repo.Migrations.CreatePastPriceRecords do
  use Ecto.Migration

  def change do
    create table(:past_price_records) do
      add :product_id, references(:products)
      add :price, :integer
      add :percentage_change, :float

      timestamps()
    end

    create index(:past_price_records, [:product_id])
  end
end
