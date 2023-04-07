defmodule Maxo.Conf.Context do
  use Construct do
    field(:name)
    field(:comment, :string, default: "")
  end
end

defmodule Maxo.Conf.Field do
  # defstruct [:name, :type, :nullable, :primary, :comment]
  use Construct do
    field(:name)
    field(:comment, :string, default: "")
    field(:type, [:string, {Construct.Types.Enum, ~w(int string decimal date datetime)}])
    field(:nullable, :boolean)
    field(:primary, :boolean)
  end
end

defmodule Maxo.Conf.Table do
  defstruct [:name, :comment]
end

defmodule Maxo.Conf.Backend do
  alias Maxo.Conf.Backend

  alias Maxo.Conf.Context
  defstruct contexts: %{}, fields: %{}, tables: %{}, relations: []

  def init() do
    %Backend{}
  end

  def add_context(backend = %Backend{}, name) do
    item = Context.make!(%{name: name})
  end
end
