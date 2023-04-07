defmodule Maxo.Conf.Query do
  alias Maxo.Conf
  alias Maxo.Conf.State
  alias Maxo.Conf.MapValue
  alias Maxo.Conf.Value
  alias Maxo.Conf.Naming

  def get_context(conf, name) do
    conf = resolve_conf(conf)

    MapValue.get(conf, "contexts.#{name}")
  end

  def get_table(conf, name) do
    conf = resolve_conf(conf)

    t = MapValue.get(conf, "tables.#{name}")
    columns = columns_for_table(conf, name)
    relations = relations_for_table(conf, name)
    indexes = indexes_for_table(conf, name)

    Value.init(t)
    |> Map.put(:columns, columns)
    |> Map.put(:relations, relations)
    |> Map.put(:indexes, indexes)
  end

  def get_column(conf, table, name) do
    conf = resolve_conf(conf)

    id = Naming.column(table, name)
    MapValue.get(conf, "columns.#{id}")
  end

  def columns_for_table(conf, table) do
    values = MapValue.get(conf, "private.columns_lookup.#{table}")
    keys = (values || %{}) |> Map.keys()

    Enum.map(keys, fn key -> MapValue.get(conf, "columns.#{key}") |> Value.init() end)
    |> Enum.sort_by(& &1.order)
  end

  def relations_for_table(conf, table) do
    values = MapValue.get(conf, "private.relations_lookup.#{table}")
    keys = (values || %{}) |> Map.keys()
    Enum.map(keys, fn key -> MapValue.get(conf, "relations.#{key}") |> Value.init() end)
  end

  def indexes_for_table(conf, table) do
    values = MapValue.get(conf, "private.indexes_lookup.#{table}")
    keys = (values || %{}) |> Map.keys()
    Enum.map(keys, fn key -> MapValue.get(conf, "indexes.#{key}") |> Value.init() end)
  end

  defp resolve_conf(conf) when is_pid(conf) do
    Conf.get_conf(conf)
  end

  defp resolve_conf(%State{} = conf) do
    conf
  end
end
