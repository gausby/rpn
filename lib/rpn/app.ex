defmodule Rpn.App do

  use Application

  def start(_type, _args) do
    case Rpn.Supervisor.start_link() do
      {:ok, pid} when is_pid(pid) ->
        {:ok, pid}
    end
  end

end
