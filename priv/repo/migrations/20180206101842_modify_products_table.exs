defmodule Pricezilla.Repo.Migrations.ModifyProductsTable do
  use Ecto.Migration

  def change do
    rename table(:products), :product_name, to: :name
  end
end
