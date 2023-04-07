defmodule Maxo.Conf.Query do
  alias Maxo.Conf
  alias Maxo.Conf.State
  alias Maxo.Conf.Value
  alias Maxo.Conf.Naming

  def get_context(conf, name) do
    conf = resolve_conf(conf)

    Value.get(conf, "contexts.#{name}")
  end

  def get_table(conf, name) do
    conf = resolve_conf(conf)

    Value.get(conf, "tables.#{name}")
  end

  def get_column(conf, table, name) do
    conf = resolve_conf(conf)

    id = Naming.column(table, name)
    Value.get(conf, "columns.#{id}")
  end

  defp resolve_conf(conf) when is_pid(conf) do
    Conf.get_conf(conf)
  end

  defp resolve_conf(%State{} = conf) do
    conf
  end
end
