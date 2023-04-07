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

      auto_assert(b)
    end
  end

  describe "add_table" do
    test "works" do
      b = Backend.init() |> Backend.add_table("users", "Our users table") |> Util.state!()

      auto_assert(b)
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

      auto_assert(b)
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

      auto_assert(b)
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

      auto_assert(b)
    end
  end
end
