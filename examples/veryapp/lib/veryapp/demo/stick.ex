defmodule Veryapp.Demo.Stick do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "sticks" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(stick, attrs) do
    stick
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
