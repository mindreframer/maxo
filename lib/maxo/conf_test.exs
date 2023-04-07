defmodule Maxo.ConfTest do
  use ExUnit.Case, async: true
  use Mneme, action: :accept, default_pattern: :last

  alias Maxo.Conf
  alias Maxo.Conf.State
  alias Maxo.Conf.Util

  setup :new_conf

  describe "add_context" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Conf.add_context(conf, "users", "our users logic"))

      auto_assert(
        %State{
          contexts: %{"users" => %Maxo.Conf.Context{comment: "our users logic", name: "users"}}
        } <- Conf.get_conf(conf)
      )
    end
  end

  describe "add_table" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Conf.add_table(conf, "users", "our users table"))

      auto_assert(
        %State{tables: %{"users" => %Maxo.Conf.Table{comment: "our users table", name: "users"}}} <-
          Conf.get_conf(conf)
      )
    end
  end

  describe "add_field" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Conf.add_field(conf, "users", %{name: "email", type: "string"}))

      auto_assert(
        %State{
          fields: %{"users/email" => %Maxo.Conf.Field{name: "email", type: "string"}},
          fields_lookup: %{"users" => %{"email" => true}}
        } <- Conf.get_conf(conf)
      )
    end
  end

  describe "add_relation" do
    test "works on valid input", %{conf: conf} do
      auto_assert(:ok <- Conf.add_table(conf, "users"))
      auto_assert(:ok <- Conf.add_field(conf, "users", %{name: "email"}))
      auto_assert(:ok <- Conf.add_table(conf, "teams"))
      auto_assert(:ok <- Conf.add_field(conf, "teams", %{name: "name"}))
      auto_assert(:ok <- Conf.add_field(conf, "teams", %{name: "owner_id", type: "int"}))
      auto_assert(:ok <- Conf.add_relation(conf, "teams/owner_id", "users/id", "o2o"))
      b = Conf.get_conf(conf)

      auto_assert(
        %State{
          fields: %{
            "teams/id" => %Maxo.Conf.Field{name: "id", primary: true, type: "int"},
            "teams/name" => %Maxo.Conf.Field{name: "name"},
            "teams/owner_id" => %Maxo.Conf.Field{name: "owner_id", type: "int"},
            "users/email" => %Maxo.Conf.Field{name: "email"},
            "users/id" => %Maxo.Conf.Field{name: "id", primary: true, type: "int"}
          },
          fields_lookup: %{
            "teams" => %{"id" => true, "name" => true, "owner_id" => true},
            "users" => %{"email" => true, "id" => true}
          },
          relations: %{
            "teams/owner_id > users/id - o2o " => %Maxo.Conf.Relation{
              dest_table: "users",
              src_field: "owner_id",
              src_table: "teams"
            }
          },
          tables: %{
            "teams" => %Maxo.Conf.Table{name: "teams"},
            "users" => %Maxo.Conf.Table{name: "users"}
          }
        } <- b
      )
    end
  end

  defp new_conf(_) do
    {:ok, conf} = Conf.start_link()
    {:ok, %{conf: conf}}
  end
end
