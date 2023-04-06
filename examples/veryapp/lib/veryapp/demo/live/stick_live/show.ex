defmodule Veryapp.Web.StickLive.Show do
  use Veryapp.Web, :live_view

  alias Veryapp.Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:stick, Demo.get_stick!(id))}
  end

  @impl true
  def render(assigns) do
    Veryapp.Web.StickLive.ShowHtml.render(assigns)
  end

  defp page_title(:show), do: "Show Stick"
  defp page_title(:edit), do: "Edit Stick"
end
