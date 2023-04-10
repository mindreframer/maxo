defmodule Maxo.Conf.Context do
  use Construct do
    field(:name)
    field(:comment, :string, default: "")
  end
end

defmodule Maxo.Conf.Column do
  use Construct do
    field(:table)
    field(:name)
    field(:comment, :string, default: "")
    field(:order, :integer)

    field(:type, [:string, {Construct.Types.Enum, ~w(int string decimal date datetime)}],
      default: "string"
    )

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

defmodule Maxo.Conf.Index do
  use Construct do
    field(:name)
    field(:table)
    field(:unique, :boolean, default: false)
    field(:columns, {:array, :string})
    field(:comment, :string, default: "")
  end
end

defmodule Maxo.Conf.Relation do
  use Construct do
    field(:comment, :string, default: "")
    field(:src_table, :string)
    field(:src_column, :string)
    field(:dest_table, :string)
    field(:dest_column, :string, default: "id")
    field(:cardinality, [:string, {Construct.Types.Enum, ~w(o2m o2o)}], default: "o2o")
  end
end
