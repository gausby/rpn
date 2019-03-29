defmodule Rpn.Engine do

  @moduledoc """
  Documentation for Reverse Polish Notation calulator.
  """

  use GenServer

  # Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :na, opts)
  end

  defp via_name(pid) when is_pid(pid) do
    pid
  end
  defp via_name(name) do
    {:via, Registry, {Rpn.Registry, name}}
  end

  def child_spec(opts) do
    %{
      id: Keyword.get(opts, :name, __MODULE__),
      start: {__MODULE__, :start_link, [opts]},
      restart: Keyword.get(opts, :restart, :transient),
      type: :worker
    }
  end

  def push(name, item) do
    GenServer.call(via_name(name), {:push, item})
  end

  def peek(name) do
    GenServer.call(via_name(name), :peek)
  end

  def reset(name) do
    GenServer.cast(via_name(name), :reset)
  end

  def stop(name) do
    GenServer.stop(via_name(name))
  end

  # Server callbacks
  @impl true
  def init(:na) do
    {:ok, []}
  end

  @impl true
  def handle_cast(:reset, _state) do
    {:noreply, []}
  end

  @impl true
  def handle_call({:push, number}, _from, state) when is_number(number) do
    {:reply, :ok, [number | state]}
  end

  def handle_call({:push, :/}, _from, [_x, 0 | _list] = state) do
    response = {:error, :division_by_zero}
    {:reply, response, state}
  end

  @operands [:+, :/, :-, :*]
  def handle_call({:push, op}, _from, [x, y | list]) when op in @operands do
    result = apply(Kernel, op, [x, y])
    new_state = [result | list]
    {:reply, result, new_state}
  end

  def handle_call({:push, otherwise}, _from, state) do
    response = {:error, {:unexpected_input, otherwise}}
    {:reply, response, state}
  end

  def handle_call(:peek, _from, state) do
    {:reply, state, state}
  end
end
