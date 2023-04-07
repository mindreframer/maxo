defmodule Maxo.Conf.Server do
  use GenServer

  @impl true
  def init(_) do
    {:ok, []}
  end
end
