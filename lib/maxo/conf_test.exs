defmodule Maxo.ConfTest do
  use ExUnit.Case, async: true
  use Mneme, action: :accept, default_pattern: :last

  alias Maxo.Conf
  alias Maxo.Conf.Util
  alias Maxo.Conf.{Context, Column, Table, State, Relation}

  setup :new_conf

  describe "add_context" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Conf.add_context(conf, "users", "our users logic"))

      b = Conf.get_conf(conf)

      auto_assert(b)
    end
  end

  describe "add_table" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Conf.add_table(conf, "users", "our users table"))

      b = Conf.get_conf(conf)

      auto_assert(b)
    end
  end

  describe "add_column" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Conf.add_column(conf, "users", %{name: "email", type: "string"}))

      b = Conf.get_conf(conf)

      auto_assert(b)
    end
  end

  describe "add_relation" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Conf.add_table(conf, "users"))
      auto_assert(:ok <- Conf.add_column(conf, "users", %{name: "email"}))
      auto_assert(:ok <- Conf.add_table(conf, "teams"))
      auto_assert(:ok <- Conf.add_column(conf, "teams", %{name: "name"}))
      auto_assert(:ok <- Conf.add_column(conf, "teams", %{name: "owner_id", type: "int"}))
      auto_assert(:ok <- Conf.add_relation(conf, "teams/owner_id", "users/id", "o2o"))

      b = Conf.get_conf(conf)

      auto_assert(b)
    end
  end

  defp new_conf(_) do
    {:ok, conf} = Conf.start_link()
    {:ok, %{conf: conf}}
  end
end
