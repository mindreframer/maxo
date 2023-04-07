defmodule Maxo.Conf.BackendTest do
  use ExUnit.Case, async: true
  use Mneme, action: :accept, default_pattern: :last
  alias Maxo.Conf.Backend
  alias Maxo.Conf.Util

  alias Maxo.Conf.{Context, Column, Table, State, Relation}

  describe "add_context" do
    test "works" do
      b =
        Backend.init()
        |> Backend.add_context("users", "Our users logic")
        |> Util.state!()

      auto_assert(
        %State{contexts: %{"users" => %Context{comment: "Our users logic", name: "users"}}} <- b
      )
    end
  end

  describe "add_table" do
    test "works" do
      b = Backend.init() |> Backend.add_table("users", "Our users table") |> Util.state!()

      auto_assert(
        %State{
          columns: %{"users/id" => %Column{name: "id", primary: true, type: "int"}},
          columns_lookup: %{"users" => %{"users/id" => true}},
          tables: %{"users" => %Table{comment: "Our users table", name: "users"}}
        } <- b
      )
    end
  end

  describe "add_column" do
    test "works" do
      b =
        Backend.init()
        |> Backend.add_table("users", "Our users table")
        |> Util.state!()
        |> Backend.add_column("users", %{name: "name", type: "string", nullable: true})
        |> Util.state!()

      auto_assert(
        %State{
          columns: %{
            "users/id" => %Column{name: "id", primary: true, type: "int"},
            "users/name" => %Column{name: "name", nullable: true}
          },
          columns_lookup: %{"users" => %{"users/id" => true, "users/name" => true}},
          tables: %{"users" => %Table{comment: "Our users table", name: "users"}}
        } <- b
      )
    end
  end

  describe "add_relation" do
    test "works" do
      b =
        Backend.init()
        |> Backend.add_table("users", "Our users table")
        |> Util.state!()
        |> Backend.add_column("users", %{name: "name", type: "string"})
        |> Util.state!()
        |> Backend.add_table("teams")
        |> Util.state!()
        |> Backend.add_column("teams", %{name: "name"})
        |> Util.state!()
        |> Backend.add_relation("teams/users_id", "users/id")
        |> Util.state!()

      auto_assert(
        %State{
          columns: %{
            "teams/id" => %Column{name: "id", primary: true, type: "int"},
            "teams/name" => %Column{name: "name"},
            "users/id" => %Column{name: "id", primary: true, type: "int"},
            "users/name" => %Column{name: "name"}
          },
          columns_lookup: %{
            "teams" => %{"teams/id" => true, "teams/name" => true},
            "users" => %{"users/id" => true, "users/name" => true}
          },
          relations: %{
            "teams/users_id > users/id : o2m " => %Relation{
              cardinality: "o2m",
              dest_table: "users",
              src_field: "users_id",
              src_table: "teams"
            }
          },
          tables: %{
            "teams" => %Table{name: "teams"},
            "users" => %Table{comment: "Our users table", name: "users"}
          }
        } <- b
      )
    end
  end

  describe "combination" do
    test "works" do
      b =
        Backend.init()
        |> Backend.add_context("users")
        |> Util.state!()
        |> Backend.add_table("users")
        |> Util.state!()

      auto_assert(
        %State{
          columns: %{"users/id" => %Column{name: "id", primary: true, type: "int"}},
          columns_lookup: %{"users" => %{"users/id" => true}},
          contexts: %{"users" => %Context{name: "users"}},
          tables: %{"users" => %Table{name: "users"}}
        } <- b
      )
    end
  end
end
