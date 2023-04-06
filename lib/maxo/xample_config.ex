defmodule Maxo.XampleConfig do
  def config(project) do
    %{
      generator: Maxo.Gen.DryhardSchema.Runner,
      project: project,
      args: [
        context: "Accounts",
        schema_module: "User",
        schema_table: "users",
        fields: [
          %{name: "name", type: :string, default: "nope"},
          %{name: "email", type: :string, required: true}
        ]
      ]
    }
  end
end

# Accounts User users name:string
