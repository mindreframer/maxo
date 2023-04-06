defmodule Veryapp.Store.Product do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :category, :string
    field :name, :string
    field :price, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :category])
    |> validate_required([:name, :price, :category])
  end
end
