defmodule Veryapp.Web.CategoryLive.ShowHtml do
  use Veryapp.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <CC.header>
      Category <%= @category.id %>
      <:subtitle>This is a category record from your database.</:subtitle>
      <:actions>
        <PhxC.link patch={~p"/categories/#{@category}/show/edit"} phx-click={JS.push_focus()}>
          <CC.button>Edit category</CC.button>
        </PhxC.link>
      </:actions>
    </CC.header>

    <CC.list>
      <:item title="Name"><%= @category.name %></:item>
      <:item title="Parent"><%= @category.parent_id %></:item>
    </CC.list>

    <CC.back navigate={~p"/categories"}>Back to categories</CC.back>

    <CC.modal
      :if={@live_action == :edit}
      id="category-modal"
      show
      on_cancel={JS.patch(~p"/categories/#{@category}")}
    >
      <PhxC.live_component
        module={Veryapp.Web.CategoryLive.FormComponent}
        id={@category.id}
        title={@page_title}
        action={@live_action}
        category={@category}
        patch={~p"/categories/#{@category}"}
      />
    </CC.modal>
    """
  end
end
