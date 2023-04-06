defmodule Veryapp.Web.StickLive.Index do
  use Veryapp.Web, :live_view

  alias Veryapp.Demo
  alias Veryapp.Demo.Stick

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :sticks, Demo.list_sticks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Stick")
    |> assign(:stick, Demo.get_stick!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Stick")
    |> assign(:stick, %Stick{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sticks")
    |> assign(:stick, nil)
  end

  @impl true
  def handle_info({Veryapp.Web.StickLive.FormComponent, {:saved, stick}}, socket) do
    {:noreply, stream_insert(socket, :sticks, stick)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    stick = Demo.get_stick!(id)
    {:ok, _} = Demo.delete_stick(stick)

    {:noreply, stream_delete(socket, :sticks, stick)}
  end

  @impl true
  def render(assigns) do
    Veryapp.Web.StickLive.IndexHtml.render(assigns)
  end
end
