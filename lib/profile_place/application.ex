defmodule ProfilePlace.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ProfilePlaceWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ProfilePlace.PubSub},
      # Start the Endpoint (http/https)
      ProfilePlaceWeb.Endpoint,
      # Start a worker by calling: ProfilePlace.Worker.start_link(arg)
      # {ProfilePlace.Worker, arg}
      {Mongo,
       [name: :db, database: "profileplace", url: System.get_env("DB_URL")]},
      {Redix, [host: "localhost", port: 6379, name: :redis]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ProfilePlace.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ProfilePlaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
