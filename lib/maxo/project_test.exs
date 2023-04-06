defmodule Maxo.ProjectTest do
  use ExUnit.Case, async: true
  use Mneme, action: :accept, default_pattern: :last

  alias Maxo.Project

  describe "prepare" do
    test "works" do
      auto_assert(
        %Project{
          app: "my_app",
          app_mod: MyApp,
          app_path: "my_app",
          core_ns: MyApp.Core,
          core_path: "my_app/lib/my_app/core"
        } <- Project.prepare("my_app")
      )
    end
  end
end
