defmodule CuekooApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CuekooApiWeb.Telemetry,
      CuekooApi.Repo,
      {DNSCluster, query: Application.get_env(:cuekoo_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CuekooApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CuekooApi.Finch},
      # Start a worker by calling: CuekooApi.Worker.start_link(arg)
      # {CuekooApi.Worker, arg},
      # Start to serve requests, typically the last entry
      CuekooApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CuekooApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CuekooApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
