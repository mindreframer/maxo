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
  use Pathex
  alias Maxo.Conf.Backend
  alias Maxo.Conf.Context
  alias Maxo.Conf.Field
  alias Maxo.Conf.Table
  defstruct contexts: %{}, fields: %{}, tables: %{}, relations: [], fields_lookup: %{}

  def init() do
    %Backend{}
  end

  def add_context(backend = %Backend{}, name, comment \\ "") do
    target = path(:contexts / name)
    item = Context.make!(%{name: name, comment: comment})

    with {:ok, backend} <- Pathex.force_set(backend, target, item) do
      {:ok, backend}
    end
  end

  def add_table(backend = %Backend{}, name, comment \\ "") do
    target = path(:tables / name)
    item = Table.make!(%{name: name, comment: comment})

    with {:ok, backend} <- Pathex.force_set(backend, target, item) do
      {:ok, backend}
    end
  end

  def add_field(backend = %Backend{}, table, args) do
    name = Map.get(args, :name) || Map.fetch!(args, "name")
    id = "#{table}.#{name}"
    target = path(:fields / id)
    item = Field.make!(args)

    with {:ok, backend} <- Pathex.force_set(backend, target, item),
         {:ok, backend} <- add_fields_lookup(backend, table, name) do
      {:ok, backend}
    end
  end

  defp add_fields_lookup(backend = %Backend{}, table, name) do
    target = path(:fields_lookup / table / name)
    table_path = path(:fields_lookup / table)

    backend =
      if Pathex.exists?(backend, table_path) do
        backend
      else
        Pathex.force_set!(backend, table_path, %{})
      end

    Pathex.force_set(backend, target, true)
  end
end
