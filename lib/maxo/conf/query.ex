defmodule Maxo.Conf.Query do
  alias Maxo.Conf
  alias Maxo.Conf.State
  alias Maxo.Conf.MapValue
  alias Maxo.Conf.Naming

  def get_context(conf, name) do
    conf = resolve_conf(conf)

    MapValue.get(conf, "contexts.#{name}")
  end

  def get_table(conf, name) do
    conf = resolve_conf(conf)

    MapValue.get(conf, "tables.#{name}")
  end

  def get_column(conf, table, name) do
    conf = resolve_conf(conf)

    id = Naming.column(table, name)
    MapValue.get(conf, "columns.#{id}")
  end

  def columns_for_table(conf, table) do
    values = MapValue.get(conf, "columns_lookup.#{table}")
    keys = (values || %{}) |> Map.keys()
    Enum.map(keys, &get_column(conf, table, &1))
  end

  defp resolve_conf(conf) when is_pid(conf) do
    Conf.get_conf(conf)
  end

  defp resolve_conf(%State{} = conf) do
    conf
  end
end
