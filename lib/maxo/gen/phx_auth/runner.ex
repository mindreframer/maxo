defmodule Maxo.Gen.PhxAuth.Runner do
  use Maxo.Generator
  # template(:new, [
  #   {:eex, :project,
  #    "app_single/config/config.exs": "config/config.exs",
  #    "app_single/config/config.exs": "config/config.exs",
  #    "app_single/config/dev.exs": "config/dev.exs",
  #    "app_single/config/prod.exs": "config/prod.exs",
  #    "app_single/config/runtime.exs": "config/runtime.exs",
  #    "app_single/config/test.exs": "config/test.exs",
  #    "app_single/lib/app_name/application.ex": "lib/:app/application.ex",
  #    "app_single/lib/app_name.ex": "lib/:app.ex",
  #    "app_web/controllers/error_json.ex": "lib/:app/core/controllers/error_json.ex",
  #    "app_web/endpoint.ex": "lib/:app/core/endpoint.ex",
  #    "app_web/router.ex": "lib/:app/core/router.ex",
  #    "app_web/telemetry.ex": "lib/:app/core/telemetry.ex",
  #    "app_single/lib/app_name_web.ex": "lib/:lib_web_name.ex",
  #    "app_single/mix.exs": "mix.exs",
  #    "app_single/README.md": "README.md",
  #    "app_single/formatter.exs": ".formatter.exs",
  #    "app_single/gitignore": ".gitignore",
  #    "app_test/support/conn_case.ex": "test/support/conn_case.ex",
  #    "app_single/test/test_helper.exs": "test/test_helper.exs",
  #    "app_single/lib/test_helper.exs": "lib/test_helper.exs",
  #    "app_test/controllers/error_json_test.exs": "lib/:app/core/controllers/error_json_test.exs"}
  # ])

  template(:new, [
    {:eex, :project,
     [
       "folder1/some.ex.eex": ":context/:feature/folder/some.ex"
     ]}
  ])

  def generate(project) do
    project
  end

  def prepare_project(project) do
    project
  end
end
