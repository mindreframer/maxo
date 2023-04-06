defmodule Veryapp.Web.StickLive.FormComponent do
  use Veryapp.Web, :live_component

  alias Veryapp.Demo

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <CC.header>
        <%= @title %>
        <:subtitle>Use this form to manage stick records in your database.</:subtitle>
      </CC.header>

      <CC.simple_form
        for={@form}
        id="stick-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <CC.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <CC.button phx-disable-with="Saving...">Save Stick</CC.button>
        </:actions>
      </CC.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{stick: stick} = assigns, socket) do
    changeset = Demo.change_stick(stick)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"stick" => stick_params}, socket) do
    changeset =
      socket.assigns.stick
      |> Demo.change_stick(stick_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"stick" => stick_params}, socket) do
    save_stick(socket, socket.assigns.action, stick_params)
  end

  defp save_stick(socket, :edit, stick_params) do
    case Demo.update_stick(socket.assigns.stick, stick_params) do
      {:ok, stick} ->
        notify_parent({:saved, stick})

        {:noreply,
         socket
         |> put_flash(:info, "Stick updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_stick(socket, :new, stick_params) do
    case Demo.create_stick(stick_params) do
      {:ok, stick} ->
        notify_parent({:saved, stick})

        {:noreply,
         socket
         |> put_flash(:info, "Stick created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
