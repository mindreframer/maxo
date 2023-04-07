defmodule Maxo.Conf.BackendTest do
  use ExUnit.Case, async: true
  use Mneme, action: :accept, default_pattern: :last
  alias Maxo.Conf.Backend
  alias Maxo.Conf.Util

  alias Maxo.Conf.{Context, Field, Table, State, Relation}

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
        %State{tables: %{"users" => %Table{comment: "Our users table", name: "users"}}} <- b
      )
    end
  end

  describe "add_field" do
    test "works" do
      b =
        Backend.init()
        |> Backend.add_table("users", "Our users table")
        |> Util.state!()
        |> Backend.add_field("users", %{name: "name", type: "string", nullable: true})
        |> Util.state!()

      auto_assert(
        %State{
          fields: %{"users/name" => %Field{name: "name", nullable: true}},
          fields_lookup: %{"users" => %{"name" => true}},
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
        |> Backend.add_field("users", %{name: "name", type: "string"})
        |> Util.state!()
        |> Backend.add_table("teams")
        |> Util.state!()
        |> Backend.add_field("teams", %{name: "name"})
        |> Util.state!()
        |> Backend.add_relation("teams.users_id", "users.id")
        |> Util.state!()

      auto_assert(
        %State{
          fields: %{"teams/name" => %Field{name: "name"}, "users/name" => %Field{name: "name"}},
          fields_lookup: %{"teams" => %{"name" => true}, "users" => %{"name" => true}},
          relations: %{
            "teams" => %{
              "users_id__o2m__users" => %{
                "id" => %Relation{
                  cardinality: "o2m",
                  dest_table: "users",
                  src_field: "users_id",
                  src_table: "teams"
                }
              }
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
          contexts: %{"users" => %Context{name: "users"}},
          tables: %{"users" => %Table{name: "users"}}
        } <- b
      )
    end
  end
end
