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

      auto_assert(
        %State{contexts: %{"users" => %Context{comment: "our users logic", name: "users"}}} <- b
      )
    end
  end

  describe "add_table" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Conf.add_table(conf, "users", "our users table"))

      b = Conf.get_conf(conf)

      auto_assert(
        %State{
          columns: %{"users/id" => %Column{name: "id", primary: true, type: "int"}},
          columns_lookup: %{"users" => %{"users/id" => true}},
          tables: %{"users" => %Table{comment: "our users table", name: "users"}}
        } <- b
      )
    end
  end

  describe "add_column" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Conf.add_column(conf, "users", %{name: "email", type: "string"}))

      b = Conf.get_conf(conf)

      auto_assert(
        %State{
          columns: %{"users/email" => %Column{name: "email"}},
          columns_lookup: %{"users" => %{"users/email" => true}}
        } <- b
      )
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

      auto_assert(
        %State{
          columns: %{
            "teams/id" => %Column{name: "id", primary: true, type: "int"},
            "teams/name" => %Column{name: "name"},
            "teams/owner_id" => %Column{name: "owner_id", type: "int"},
            "users/email" => %Column{name: "email"},
            "users/id" => %Column{name: "id", primary: true, type: "int"}
          },
          columns_lookup: %{
            "teams" => %{"teams/id" => true, "teams/name" => true, "teams/owner_id" => true},
            "users" => %{"users/email" => true, "users/id" => true}
          },
          relations: %{
            "teams/owner_id > users/id : o2o " => %Relation{
              dest_table: "users",
              src_field: "owner_id",
              src_table: "teams"
            }
          },
          tables: %{"teams" => %Table{name: "teams"}, "users" => %Table{name: "users"}}
        } <- b
      )
    end
  end

  defp new_conf(_) do
    {:ok, conf} = Conf.start_link()
    {:ok, %{conf: conf}}
  end
end
