defmodule Maxo.Conf.QueryTest do
  use ExUnit.Case, async: true
  use MnemeDefauls
  alias Maxo.Conf.Query
  alias Maxo.Conf.Util
  alias Maxo.Conf.{Context, Column, Table, State, Relation}

  setup :setup_conf

  describe "get_table" do
    test "users - works", %{conf: conf} do
      res = Query.get_table(conf, "users")

      auto_assert(
        %{
          columns: [
            %{
              comment: "",
              name: "id",
              nullable: false,
              order: 1,
              primary: true,
              table: "users",
              type: "int"
            },
            %{
              comment: "",
              name: "name",
              nullable: false,
              order: 2,
              primary: false,
              table: "users",
              type: "string"
            },
            %{
              comment: "",
              name: "email",
              nullable: false,
              order: 3,
              primary: false,
              table: "users",
              type: "string"
            },
            %{
              comment: "",
              name: "password_hash",
              nullable: false,
              order: 4,
              primary: false,
              table: "users",
              type: "string"
            }
          ],
          comment: "",
          indexes: [
            %{
              columns: ["email"],
              comment: "",
              name: "users_email_index",
              table: "users",
              unique: true
            }
          ],
          name: "users",
          relations: [
            %{
              cardinality: "o2m",
              comment: "",
              dest_column: "id",
              dest_table: "users",
              src_column: "users_id",
              src_table: "memberships"
            }
          ]
        } <- res
      )
    end

    test "memberships - works", %{conf: conf} do
      res = Query.get_table(conf, "memberships")

      auto_assert(
        %{
          columns: [
            %{
              comment: "",
              name: "id",
              nullable: false,
              order: 1,
              primary: true,
              table: "memberships",
              type: "int"
            },
            %{
              comment: "",
              name: "users_id",
              nullable: false,
              order: 2,
              primary: false,
              table: "memberships",
              type: "int"
            },
            %{
              comment: "",
              name: "teams_id",
              nullable: false,
              order: 3,
              primary: false,
              table: "memberships",
              type: "int"
            }
          ],
          comment: "",
          indexes: [
            %{
              columns: ["teams_id"],
              comment: "",
              name: "memberships_teams_id_index",
              table: "memberships",
              unique: false
            },
            %{
              columns: ["users_id"],
              comment: "",
              name: "memberships_users_id_index",
              table: "memberships",
              unique: false
            }
          ],
          name: "memberships",
          relations: [
            %{
              cardinality: "o2m",
              comment: "",
              dest_column: "id",
              dest_table: "teams",
              src_column: "teams_id",
              src_table: "memberships"
            },
            %{
              cardinality: "o2m",
              comment: "",
              dest_column: "id",
              dest_table: "users",
              src_column: "users_id",
              src_table: "memberships"
            }
          ]
        } <- res
      )
    end
  end

  describe "get_column" do
    test "works", %{conf: conf} do
      res = Query.get_column(conf, "teams", "name")

      auto_assert(
        %{
          comment: "",
          name: "name",
          nullable: false,
          order: 2,
          primary: false,
          table: "teams",
          type: "string"
        } <- res
      )
    end

    test "nil for non-existing", %{conf: conf} do
      res = Query.get_column(conf, "teams", "does-not-exist")
      auto_assert(nil <- res)
    end
  end

  defp setup_conf(_) do
    {:ok, conf} = Maxo.Conf.start_link()

    Maxo.Conf.add_context!(conf, "users")
    Maxo.Conf.add_context!(conf, "tags")
    Maxo.Conf.add_context!(conf, "voting")
    Maxo.Conf.add_context!(conf, "profiles")

    Maxo.Conf.add_context!(conf, "admin/users")
    Maxo.Conf.add_context!(conf, "admin/profiles")

    Maxo.Conf.add_table!(conf, "users")
    Maxo.Conf.add_column!(conf, "users", %{name: "name", type: "string", nullable: false})
    Maxo.Conf.add_column!(conf, "users", %{name: "email", type: "string", nullable: false})
    Maxo.Conf.add_index!(conf, "users", ["email"], unique: true)

    Maxo.Conf.add_column!(conf, "users", %{name: "password_hash", type: "string", nullable: false})

    Maxo.Conf.add_table!(conf, "teams")
    Maxo.Conf.add_column!(conf, "teams", %{name: "name", type: "string", nullable: false})

    Maxo.Conf.add_table!(conf, "memberships")
    Maxo.Conf.add_column!(conf, "memberships", %{name: "users_id", type: "int", nullable: false})
    Maxo.Conf.add_column!(conf, "memberships", %{name: "teams_id", type: "int", nullable: false})
    Maxo.Conf.add_index!(conf, "memberships", ["users_id"])
    Maxo.Conf.add_index!(conf, "memberships", ["teams_id"])

    ## relations can be executed after all tables, that simplifies DB schema maintenance
    Maxo.Conf.add_relation!(conf, "memberships/users_id", "users/id", "o2m")
    Maxo.Conf.add_relation!(conf, "memberships/teams_id", "teams/id", "o2m")
    {:ok, %{conf: conf}}
  end
end
