defmodule Mix.Tasks.Maxo.Gen.ContextTest do
  use ExUnit.Case
  use MnemeDefaults

  alias Mix.Tasks.Maxo.Gen

  test "works" do
    args = "Store Product products name:string price:integer category:string" |> String.split()

    {context, schema} = Gen.Context.build(args)

    auto_assert(
      %Mix.Maxo.Context{
        alias: Store,
        base_module: Maxo,
        basename: "store",
        context_app: :maxo,
        dir: "lib/maxo/store",
        file: "lib/maxo/store/store.ex",
        module: Maxo.Store,
        name: "Store",
        opts: [schema: true, context: true],
        schema: %Mix.Maxo.Schema{
          alias: Product,
          api_route_prefix: "/api/products",
          attrs: [name: :string, price: :integer, category: :string],
          binary_id: nil,
          collection: "products",
          context_app: :maxo,
          defaults: %{category: "", name: "", price: ""},
          file: "lib/maxo/store/product.ex",
          fixture_params: %{category: "\"some category\"", name: "\"some name\"", price: "42"},
          human_plural: "Products",
          human_singular: "Product",
          live_routing_module: Maxo.Web.ProductLiveRouting,
          migration?: true,
          migration_defaults: %{category: "", name: "", price: ""},
          migration_module: Ecto.Migration,
          module: Maxo.Store.Product,
          opts: [schema: true, context: true],
          params: %{
            create: %{category: "some category", name: "some name", price: 42},
            default_key: :category,
            update: %{category: "some updated category", name: "some updated name", price: 43}
          },
          plural: "products",
          repo: Maxo.Repo,
          route_helper: "product",
          route_prefix: "/products",
          sample_id: -1,
          singular: "product",
          string_attr: :category,
          table: "products",
          types: %{category: :string, name: :string, price: :integer}
        },
        test_file: "lib/maxo/store/store_test.exs",
        test_fixtures_file: "test/support/fixtures/store_fixtures.ex",
        web_module: Maxo.Web
      } <- context
    )

    auto_assert(
      %Mix.Maxo.Schema{
        alias: Product,
        api_route_prefix: "/api/products",
        attrs: [name: :string, price: :integer, category: :string],
        binary_id: nil,
        collection: "products",
        context_app: :maxo,
        defaults: %{category: "", name: "", price: ""},
        file: "lib/maxo/store/product.ex",
        fixture_params: %{category: "\"some category\"", name: "\"some name\"", price: "42"},
        human_plural: "Products",
        human_singular: "Product",
        live_routing_module: Maxo.Web.ProductLiveRouting,
        migration?: true,
        migration_defaults: %{category: "", name: "", price: ""},
        migration_module: Ecto.Migration,
        module: Maxo.Store.Product,
        opts: [schema: true, context: true],
        params: %{
          create: %{category: "some category", name: "some name", price: 42},
          default_key: :category,
          update: %{category: "some updated category", name: "some updated name", price: 43}
        },
        plural: "products",
        repo: Maxo.Repo,
        route_helper: "product",
        route_prefix: "/products",
        sample_id: -1,
        singular: "product",
        string_attr: :category,
        table: "products",
        types: %{category: :string, name: :string, price: :integer}
      } <- schema
    )
  end
end
