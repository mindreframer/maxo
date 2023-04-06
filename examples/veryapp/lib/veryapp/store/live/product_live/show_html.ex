defmodule Veryapp.Web.ProductLive.ShowHtml do
  use Veryapp.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <CC.header>
      Product <%= @product.id %>
      <:subtitle>This is a product record from your database.</:subtitle>
      <:actions>
        <PhxC.link patch={~p"/products/#{@product}/show/edit"} phx-click={JS.push_focus()}>
          <CC.button>Edit product</CC.button>
        </PhxC.link>
      </:actions>
    </CC.header>

    <CC.list>
      <:item title="Name"><%= @product.name %></:item>
      <:item title="Price"><%= @product.price %></:item>
      <:item title="Category"><%= @product.category %></:item>
    </CC.list>

    <CC.back navigate={~p"/products"}>Back to products</CC.back>

    <CC.modal
      :if={@live_action == :edit}
      id="product-modal"
      show
      on_cancel={JS.patch(~p"/products/#{@product}")}
    >
      <PhxC.live_component
        module={Veryapp.Web.ProductLive.FormComponent}
        id={@product.id}
        title={@page_title}
        action={@live_action}
        product={@product}
        patch={~p"/products/#{@product}"}
      />
    </CC.modal>
    """
  end
end
