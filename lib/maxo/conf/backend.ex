defmodule Maxo.Conf.Context do
  use Construct do
    field(:name)
    field(:comment, :string, default: "")
  end
end

defmodule Maxo.Conf.Field do
  use Construct do
    field(:name)
    field(:comment, :string, default: "")
    field(:type, [:string, {Construct.Types.Enum, ~w(int string decimal date datetime)}])
    field(:nullable, :boolean, default: false)
    field(:primary, :boolean, default: false)
  end
end

defmodule Maxo.Conf.Table do
  use Construct do
    field(:name)
    field(:comment, :string, default: "")
  end
end

defmodule Maxo.Conf.Backend do
  alias Maxo.Conf.Util
  alias Maxo.Conf.Backend
  alias Maxo.Conf.Context
  alias Maxo.Conf.Field
  alias Maxo.Conf.Table
  defstruct contexts: %{}, fields: %{}, tables: %{}, relations: [], fields_lookup: %{}

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
