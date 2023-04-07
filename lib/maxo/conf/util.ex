defmodule Maxo.Conf.Util do
  def ok!({_state, {:ok, v}}) do
    {:ok, v}
  end

  def ok!({_state, :ok}) do
    :ok
  end

  def error!({_state, {:error, v}}) do
    {:error, v}
  end

  def state!({state, :ok}), do: state
  def state!({state, {:ok, _}}), do: state
end
