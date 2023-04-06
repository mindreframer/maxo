defmodule Veryapp.Web.ProductLive.Show do
  use Veryapp.Web, :live_view

  alias Veryapp.Store

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Store.get_product!(id))}
  end

  @impl true
  def render(assigns) do
    Veryapp.Web.ProductLive.ShowHtml.render(assigns)
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
