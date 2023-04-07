defmodule Maxo.Conf.ServerTest do
  use ExUnit.Case, async: true
  use Mneme, action: :accept, default_pattern: :last

  alias Maxo.Conf.Server
  alias Maxo.Conf.State
  alias Maxo.Conf.Util

  setup :new_server

  describe "add_context" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Server.add_context(conf, "users", "our users logic"))

      auto_assert(
        %State{
          contexts: %{"users" => %Maxo.Conf.Context{comment: "our users logic", name: "users"}}
        } <- Server.get_conf(conf)
      )
    end
  end

  describe "add_table" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Server.add_table(conf, "users", "our users table"))

      auto_assert(
        %State{tables: %{"users" => %Maxo.Conf.Table{comment: "our users table", name: "users"}}} <-
          Server.get_conf(conf)
      )
    end
  end

  describe "add_field" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Server.add_field(conf, "users", %{name: "email", type: "string"}))

      auto_assert(
        %State{
          fields: %{"users/email" => %Maxo.Conf.Field{name: "email", type: "string"}},
          fields_lookup: %{"users" => %{"email" => true}}
        } <- Server.get_conf(conf)
      )
    end
  end

  defp new_server(_) do
    {:ok, conf} = Server.start_link()
    {:ok, %{conf: conf}}
  end
end
