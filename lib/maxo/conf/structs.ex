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
