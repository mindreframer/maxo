defmodule Veryapp.StoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Veryapp.Store` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        category: "some category",
        name: "some name",
        price: 42
      })
      |> Veryapp.Store.create_product()

    product
  end

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: "some name",
        parent_id: 42
      })
      |> Veryapp.Store.create_category()

    category
  end
end
