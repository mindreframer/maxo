defmodule Veryapp.Web.ProductLive.IndexHtml do
  use Veryapp.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <CC.header>
      Listing Products
      <:actions>
        <PhxC.link patch={~p"/products/new"}>
          <CC.button>New Product</CC.button>
        </PhxC.link>
      </:actions>
    </CC.header>

    <CC.table
      id="products"
      rows={@streams.products}
      row_click={fn {_id, product} -> JS.navigate(~p"/products/#{product}") end}
    >
      <:col :let={{_id, product}} label="Name"><%= product.name %></:col>
      <:col :let={{_id, product}} label="Price"><%= product.price %></:col>
      <:col :let={{_id, product}} label="Category"><%= product.category %></:col>
      <:action :let={{_id, product}}>
        <div class="sr-only">
          <PhxC.link navigate={~p"/products/#{product}"}>Show</PhxC.link>
        </div>
        <PhxC.link patch={~p"/products/#{product}/edit"}>Edit</PhxC.link>
      </:action>
      <:action :let={{id, product}}>
        <PhxC.link
          phx-click={JS.push("delete", value: %{id: product.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </PhxC.link>
      </:action>
    </CC.table>

    <CC.modal
      :if={@live_action in [:new, :edit]}
      id="product-modal"
      show
      on_cancel={JS.patch(~p"/products")}
    >
      <PhxC.live_component
        module={Veryapp.Web.ProductLive.FormComponent}
        id={@product.id || :new}
        title={@page_title}
        action={@live_action}
        product={@product}
        patch={~p"/products"}
      />
    </CC.modal>
    """
  end
end
