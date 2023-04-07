defmodule Maxo.Conf.Util do
  def ok(res), do: {:ok, res}
  def error(res), do: {:error, res}
  def ok!({:ok, res}), do: res
  def error!({:error, res}), do: res
end
