defmodule Veryapp.Web.StickLive.IndexHtml do
  use Veryapp.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <CC.header>
      Listing Sticks
      <:actions>
        <PhxC.link patch={~p"/sticks/new"}>
          <CC.button>New Stick</CC.button>
        </PhxC.link>
      </:actions>
    </CC.header>

    <CC.table
      id="sticks"
      rows={@streams.sticks}
      row_click={fn {_id, stick} -> JS.navigate(~p"/sticks/#{stick}") end}
    >
      <:col :let={{_id, stick}} label="Name"><%= stick.name %></:col>
      <:action :let={{_id, stick}}>
        <div class="sr-only">
          <PhxC.link navigate={~p"/sticks/#{stick}"}>Show</PhxC.link>
        </div>
        <PhxC.link patch={~p"/sticks/#{stick}/edit"}>Edit</PhxC.link>
      </:action>
      <:action :let={{id, stick}}>
        <PhxC.link
          phx-click={JS.push("delete", value: %{id: stick.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </PhxC.link>
      </:action>
    </CC.table>

    <CC.modal :if={@live_action in [:new, :edit]} id="stick-modal" show on_cancel={JS.patch(~p"/sticks")}>
      <PhxC.live_component
        module={Veryapp.Web.StickLive.FormComponent}
        id={@stick.id || :new}
        title={@page_title}
        action={@live_action}
        stick={@stick}
        patch={~p"/sticks"}
      />
    </CC.modal>
    """
  end
end
