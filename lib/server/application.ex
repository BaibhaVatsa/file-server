defmodule Server.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {Server, port: 8080}
    ]

    opts = [strategy: :one_for_one, name: Server.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
