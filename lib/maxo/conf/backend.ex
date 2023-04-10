defmodule Maxo.Conf.Backend do
  alias Maxo.Conf.{Context, Column, Table, State, Relation, Index}
  alias Maxo.Conf.MapValue
  alias Maxo.Conf.Naming

  def init() do
    %State{}
  end

  def add_context(state = %State{}, name, comment \\ "") do
    item = Context.make!(%{name: name, comment: comment})
    state = MapValue.insert(state, "contexts.#{name}", item)
    ok(state)
  end

  def add_table(state = %State{}, name, comment \\ "") do
    item = Table.make!(%{name: name, comment: comment})
    state = MapValue.insert(state, "tables.#{name}", item)

    state =
      state
      |> add_column(name, %{name: "id", primary: true, type: "int"})
      |> Maxo.Conf.Util.state!()

    ok(state)
  end

  def add_column(state = %State{}, table, args) do
    counter = get_columns_counter(state, table)

    item =
      args
      |> Map.merge(%{order: counter, table: table})
      |> Column.make!()

    name = Map.get(args, :name) || Map.fetch!(args, "name")
    id = Naming.column(table, name)

    state =
      state
      |> MapValue.insert("columns.#{id}", item)
      |> add_columns_lookup(table, id)
      |> inc_columns_counter(table)

    ok(state)
  end

  def add_index(state = %State{}, table, columns, opts \\ []) do
    unique = Keyword.get(opts, :unique, false)
    # type = Keyword.get(opts, :type, "btree")
    name = "#{table}_#{Enum.join(columns, "_")}_index"

    item =
      %{
        name: name,
        table: table,
        unique: unique,
        columns: columns
      }
      |> Index.make!()

    state =
      state
      |> MapValue.insert("indexes.#{name}", item)
      |> add_indexes_lookup(table, name)

    ok(state)
  end

  def add_relation(state = %State{}, src, dest, cardinality \\ "o2m") do
    [src_table, src_column] = String.split(src, "/")
    [dest_table, dest_column] = String.split(dest, "/")

    id = Naming.relation(src, dest, cardinality)

    item =
      Relation.make!(%{
        src_table: src_table,
        src_column: src_column,
        dest_table: dest_table,
        dest_column: dest_column,
        cardinality: cardinality
      })

    state =
      state
      |> MapValue.insert("relations.#{id}", item)
      |> add_relations_lookup(src_table, id, "out")
      |> add_relations_lookup(dest_table, id, "in")

    ok(state)
  end

  defp add_columns_lookup(state = %State{}, table, name) do
    MapValue.insert(state, "private.columns_lookup.#{table}.#{name}", true)
  end

  defp add_indexes_lookup(state = %State{}, table, name) do
    MapValue.insert(state, "private.indexes_lookup.#{table}.#{name}", true)
  end

  defp add_relations_lookup(state = %State{}, table, name, type) do
    MapValue.insert(state, "private.relations_lookup.#{table}.#{name}", type)
  end

  def inc_columns_counter(state = %State{}, table) do
    value = get_columns_counter(state, table)
    MapValue.insert(state, "private.columns_counter.#{table}", value + 1)
  end

  def get_columns_counter(state = %State{}, table) do
    MapValue.get(state, "private.columns_counter.#{table}") || 1
  end

  defp ok(state), do: {state, :ok}
  # defp ok(state, res), do: {state, {:ok, res}}
  # defp error(state, res), do: {state, {:error, res}}
end
