defmodule Maxo.Conf.BackendTest do
  use ExUnit.Case, async: true
  use Mneme, action: :accept, default_pattern: :last
  alias Maxo.Conf.Backend
  alias Maxo.Conf.Util

  describe "add_context" do
    test "works" do
      b =
        Backend.init()
        |> Backend.add_context("users", "Our users logic")

      auto_assert(
        {:ok,
         %Backend{
           contexts: %{"users" => %Maxo.Conf.Context{comment: "Our users logic", name: "users"}}
         }} <- b
      )
    end
  end

  describe "add_table" do
    test "works" do
      b = Backend.init() |> Backend.add_table!("users", "Our users table")

      auto_assert(
        %Backend{
          tables: %{"users" => %Maxo.Conf.Table{comment: "Our users table", name: "users"}}
        } <- b
      )
    end
  end

  describe "add_field" do
    test "works" do
      b =
        Backend.init()
        |> Backend.add_table!("users", "Our users table")
        |> Backend.add_field!("users", %{name: "name", type: "string", nullable: true})

      auto_assert(
        %Backend{
          fields: %{
            "users/name" => %Maxo.Conf.Field{name: "name", nullable: true, type: "string"}
          },
          fields_lookup: %{"users" => %{"name" => true}},
          tables: %{"users" => %Maxo.Conf.Table{comment: "Our users table", name: "users"}}
        } <- b
      )
    end
  end

  describe "combination" do
    test "works" do
      b =
        Backend.init()
        |> Backend.add_context!("users")
        |> Backend.add_table!("users")

      auto_assert(
        %Backend{
          contexts: %{"users" => %Maxo.Conf.Context{name: "users"}},
          tables: %{"users" => %Maxo.Conf.Table{name: "users"}}
        } <- b
      )
    end
  end
end
