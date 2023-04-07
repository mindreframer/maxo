defmodule Maxo.Conf.Backend do
  alias Maxo.Conf.{Context, Field, Table, State}

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

  defp add_fields_lookup(state = %State{}, table, name) do
    Value.insert(state, "fields_lookup.#{table}.#{name}", true)
  end

  defp ok(state), do: {state, :ok}
  # defp ok(state, res), do: {state, {:ok, res}}
  # defp error(state, res), do: {state, {:error, res}}
end
