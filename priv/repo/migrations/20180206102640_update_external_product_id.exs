defmodule Pricezilla.Repo.Migrations.UpdateExternalProductId do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :external_product_id, :string
    end
  end
end
