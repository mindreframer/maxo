defmodule Maxo.Gen.DryhardSchema.Runner do
  use Maxo.Generator

  template(:new, [
    {:eex, :project,
     [
       "schema.ex.eex": ":context/:feature/schema.ex"
     ]}
  ])

  def generate(project) do
    project
  end

  def prepare_project(project) do
    project
  end
end
