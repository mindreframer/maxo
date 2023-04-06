defmodule Veryapp.Web.CategoryLive.IndexHtml do
  use Veryapp.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <CC.header>
      Listing Categories
      <:actions>
        <PhxC.link patch={~p"/categories/new"}>
          <CC.button>New Category</CC.button>
        </PhxC.link>
      </:actions>
    </CC.header>

    <CC.table
      id="categories"
      rows={@streams.categories}
      row_click={fn {_id, category} -> JS.navigate(~p"/categories/#{category}") end}
    >
      <:col :let={{_id, category}} label="Name"><%= category.name %></:col>
      <:col :let={{_id, category}} label="Parent"><%= category.parent_id %></:col>
      <:action :let={{_id, category}}>
        <div class="sr-only">
          <PhxC.link navigate={~p"/categories/#{category}"}>Show</PhxC.link>
        </div>
        <PhxC.link patch={~p"/categories/#{category}/edit"}>Edit</PhxC.link>
      </:action>
      <:action :let={{id, category}}>
        <PhxC.link
          phx-click={JS.push("delete", value: %{id: category.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </PhxC.link>
      </:action>
    </CC.table>

    <CC.modal
      :if={@live_action in [:new, :edit]}
      id="category-modal"
      show
      on_cancel={JS.patch(~p"/categories")}
    >
      <PhxC.live_component
        module={Veryapp.Web.CategoryLive.FormComponent}
        id={@category.id || :new}
        title={@page_title}
        action={@live_action}
        category={@category}
        patch={~p"/categories"}
      />
    </CC.modal>
    """
  end
end
