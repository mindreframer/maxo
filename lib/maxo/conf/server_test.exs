defmodule Maxo.Conf.ServerTest do
  use ExUnit.Case, async: true
  use Mneme, action: :accept, default_pattern: :last
  alias Maxo.Conf.Server
  alias Maxo.Conf.Util

  setup :new_server

  describe "add_context!" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Server.add_context!(conf, "users", "our users logic"))
    end

    test "raises on invalid input", %{conf: conf} do
      # assert_raise RuntimeError, "{{:error, :not_found}, {:read!, \"/a\"}}", fn ->
      #   auto_assert(:ok <- Virtfs.read!(fs, "/a"))
      # end
    end
  end

  defp new_server(_) do
    {:ok, conf} = Server.start_link()
    {:ok, %{conf: conf}}
  end
end
