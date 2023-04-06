defmodule Maxo.Project do
  defstruct app: nil, app_mod: nil, app_path: nil, core_path: nil, core_ns: nil, fs: nil
  # alias Maxo.Project

  def prepare(project_path, opts \\ []) do
    app = opts[:app] || Path.basename(project_path)
    app_mod = Module.concat([opts[:module] || Macro.camelize(app)])
    app_path = project_path

    core_path = Path.join([app_path, "lib", app_path, "core"])
    core_ns = Module.concat(["#{app_mod}.Core"])

    {:ok, fs} = Virtfs.start_link()

    %Maxo.Project{
      app: app,
      app_mod: app_mod,
      app_path: app_path,
      core_path: core_path,
      core_ns: core_ns,
      fs: fs
    }
  end

  #  def join_path(%Project{} = project, location, path)
  #     when location in [:project, :app, :web] do
  #   project
  #   |> Map.fetch!(:"#{location}_path")
  #   |> Path.join(path)
  #   |> expand_path_with_bindings(project)
  # end

  # defp expand_path_with_bindings(path, %Project{} = project) do
  #   Regex.replace(Regex.recompile!(~r/:[a-zA-Z0-9_]+/), path, fn ":" <> key, _ ->
  #     project |> Map.fetch!(:"#{key}") |> to_string()
  #   end)
  # end
end
