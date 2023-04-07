defmodule Maxo.Conf.Backend do
  defstruct contexts: %{}, fields: %{}, tables: %{}, relations: [], fields_lookup: %{}

  alias __MODULE__
  alias Maxo.Conf.{Context, Field, Table}
  alias Maxo.Conf.Util

  def init() do
    %Backend{}
  end

  def add_context(backend = %Backend{}, name, comment \\ "") do
    item = Context.make!(%{name: name, comment: comment})
    backend = Value.insert(backend, "contexts.#{name}", item)
    Util.ok(backend)
  end

  def add_table(backend = %Backend{}, name, comment \\ "") do
    item = Table.make!(%{name: name, comment: comment})
    backend = Value.insert(backend, "tables.#{name}", item)
    Util.ok(backend)
  end

  def add_field(backend = %Backend{}, table, args) do
    item = Field.make!(args)
    name = Map.get(args, :name) || Map.fetch!(args, "name")
    id = "#{table}/#{name}"

    backend =
      backend
      |> Value.insert("fields.#{id}", item)
      |> add_fields_lookup(table, name)

    Util.ok(backend)
  end

  defp add_fields_lookup(backend = %Backend{}, table, name) do
    Value.insert(backend, "fields_lookup.#{table}.#{name}", true)
  end
end
