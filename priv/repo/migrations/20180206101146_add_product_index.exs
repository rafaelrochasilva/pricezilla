defmodule Pricezilla.Repo.Migrations.AddProductIndex do
  use Ecto.Migration

  def change do
    create index(:products, [:external_product_id])
  end
end
