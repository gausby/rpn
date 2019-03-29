defmodule Rpn.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :na, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Registry, [keys: :unique, name: Rpn.Registry]},
      {Rpn.Engine.Supervisor, []}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
