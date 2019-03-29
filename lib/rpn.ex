defmodule Rpn do

  defdelegate new(), to: Rpn.Engine.Supervisor, as: :start_child

  defdelegate new(name), to: Rpn.Engine.Supervisor, as: :start_child

  defdelegate push(pid, op), to: Rpn.Engine

  defdelegate reset(pid), to: Rpn.Engine

  defdelegate peek(pid), to: Rpn.Engine

  defdelegate stop(pid), to: Rpn.Engine, as: :destroy

end
