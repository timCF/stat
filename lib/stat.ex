defmodule Stat do
  use Application
  use Tinca, [:__stat_cache__]
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Tinca.declare_namespaces

    children = [
                  worker(Stat.Server, [])
      # Define workers and child supervisors to be supervised
      # worker(Stat.Worker, [arg1, arg2, arg3])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Stat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
