defmodule Maxo.Conf.Backend do
  alias Maxo.Conf.{Context, Field, Table, State, Relation}

  def init() do
    %State{}
  end

  def add_context(state = %State{}, name, comment \\ "") do
    item = Context.make!(%{name: name, comment: comment})
    state = Value.insert(state, "contexts.#{name}", item)
    ok(state)
  end

  def add_table(state = %State{}, name, comment \\ "") do
    item = Table.make!(%{name: name, comment: comment})
    state = Value.insert(state, "tables.#{name}", item)

    state =
      state
      |> add_field(name, %{name: "id", primary: true, type: "int"})
      |> Maxo.Conf.Util.state!()

    ok(state)
  end

  def add_field(state = %State{}, table, args) do
    item = Field.make!(args)
    name = Map.get(args, :name) || Map.fetch!(args, "name")
    id = "#{table}/#{name}"

    state =
      state
      |> Value.insert("fields.#{id}", item)
      |> add_fields_lookup(table, name)

    ok(state)
  end

  def add_relation(state = %State{}, src, dest, cardinality \\ "o2m") do
    [src_table, src_field] = String.split(src, "/")
    [dest_table, dest_field] = String.split(dest, "/")

    name = "#{src} -> #{dest} :: #{cardinality} "

    item =
      Relation.make!(%{
        src_table: src_table,
        src_field: src_field,
        dest_table: dest_table,
        dest_field: dest_field,
        cardinality: cardinality
      })

    state =
      state
      |> Value.insert("relations.#{name}", item)

    ok(state)
  end

  defp add_fields_lookup(state = %State{}, table, name) do
    Value.insert(state, "fields_lookup.#{table}.#{name}", true)
  end

  defp ok(state), do: {state, :ok}
  # defp ok(state, res), do: {state, {:ok, res}}
  # defp error(state, res), do: {state, {:error, res}}
end
