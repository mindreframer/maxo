defmodule <%= @app_module %>.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      <%= @web_namespace %>.Telemetry,<%= if @ecto do %>
      # Start the Ecto repository
      <%= @app_module %>.Repo,<% end %>
      # Start the PubSub system
      {Phoenix.PubSub, name: <%= @app_module %>.PubSub},<%= if @mailer do %>
      # Start Finch
      {Finch, name: <%= @app_module %>.Finch},<% end %>
      # Start the Endpoint (http/https)
      <%= @endpoint_module %>
      # Start a worker by calling: <%= @app_module %>.Worker.start_link(arg)
      # {<%= @app_module %>.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: <%= @app_module %>.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    <%= @endpoint_module %>.config_change(changed, removed)
    :ok
  end
end
