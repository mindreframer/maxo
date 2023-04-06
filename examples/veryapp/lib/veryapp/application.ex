defmodule Veryapp.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Veryapp.Web.Telemetry,
      # Start the Ecto repository
      Veryapp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Veryapp.PubSub},
      # Start Finch
      {Finch, name: Veryapp.Finch},
      # Start the Endpoint (http/https)
      Veryapp.Web.Endpoint
      # Start a worker by calling: Veryapp.Worker.start_link(arg)
      # {Veryapp.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: Veryapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Veryapp.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
