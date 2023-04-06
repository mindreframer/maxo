defmodule Veryapp.Repo.Migrations.CreateSticks do
  use Ecto.Migration

  def change do
    create table(:sticks) do
      add :name, :string

      timestamps()
    end
  end
end
