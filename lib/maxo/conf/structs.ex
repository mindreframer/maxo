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

defmodule Maxo.Conf.Relation do
  use Construct do
    field(:comment, :string, default: "")
    field(:src_table, :string)
    field(:src_field, :string)
    field(:dest_table, :string)
    field(:dest_field, :string, default: "id")
    field(:cardinality, [:string, {Construct.Types.Enum, ~w(o2m o2o)}], default: "o2o")
  end
end
