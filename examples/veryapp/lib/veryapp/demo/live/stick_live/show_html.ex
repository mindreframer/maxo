defmodule Veryapp.Web.StickLive.ShowHtml do
  use Veryapp.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <CC.header>
      Stick <%= @stick.id %>
      <:subtitle>This is a stick record from your database.</:subtitle>
      <:actions>
        <PhxC.link patch={~p"/sticks/#{@stick}/show/edit"} phx-click={JS.push_focus()}>
          <CC.button>Edit stick</CC.button>
        </PhxC.link>
      </:actions>
    </CC.header>

    <CC.list>
      <:item title="Name"><%= @stick.name %></:item>
    </CC.list>

    <CC.back navigate={~p"/sticks"}>Back to sticks</CC.back>

    <CC.modal :if={@live_action == :edit} id="stick-modal" show on_cancel={JS.patch(~p"/sticks/#{@stick}")}>
      <PhxC.live_component
        module={Veryapp.Web.StickLive.FormComponent}
        id={@stick.id}
        title={@page_title}
        action={@live_action}
        stick={@stick}
        patch={~p"/sticks/#{@stick}"}
      />
    </CC.modal>
    """
  end
end
