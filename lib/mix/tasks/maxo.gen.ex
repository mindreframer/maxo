defmodule Mix.Tasks.Maxo.Gen do
  use Mix.Task

  @shortdoc "Lists all available Phoenix generators"

  @moduledoc """
  Lists all available Phoenix generators.

  ## CRUD related generators

  The table below shows a summary of the contents created by the CRUD generators:

  | Task | Schema | Migration | Context | Controller | View | LiveView |
  |:------------------ |:-:|:-:|:-:|:-:|:-:|:-:|
  | `maxo.gen.embedded` | ✓ |   |   |   |   |   |
  | `maxo.gen.schema`   | ✓ | ✓ |   |   |   |   |
  | `maxo.gen.context`  | ✓ | ✓ | ✓ |   |   |   |
  | `maxo.gen.live`     | ✓ | ✓ | ✓ |   |   | ✓ |
  | `maxo.gen.json`     | ✓ | ✓ | ✓ | ✓ | ✓ |   |
  | `maxo.gen.html`     | ✓ | ✓ | ✓ | ✓ | ✓ |   |
  """

  def run(_args) do
    Mix.Task.run("help", ["--search", "maxo.gen."])
  end
end
