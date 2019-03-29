defmodule Rpn.Engine.Supervisor do
  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :na, name: __MODULE__)
  end

  def start_child() do
    spec = {Rpn.Engine, [restart: :transient]}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def start_child(name) do
    spec = {Rpn.Engine, [restart: :transient, name: {:via, Registry, {Rpn.Registry, name}}]}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(:na) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
