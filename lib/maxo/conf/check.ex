defmodule Maxo.Conf.Check do
  def run do
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

    Maxo.Conf.add_column!(conf, "users", %{name: "password_hash", type: "string", nullable: false})

    Maxo.Conf.add_table!(conf, "teams")
    Maxo.Conf.add_column!(conf, "teams", %{name: "name", type: "string", nullable: false})

    Maxo.Conf.add_table!(conf, "memberships")
    Maxo.Conf.add_column!(conf, "memberships", %{name: "users_id", type: "int", nullable: false})
    Maxo.Conf.add_column!(conf, "memberships", %{name: "teams_id", type: "int", nullable: false})

    ## relations can be executed after all tables, that simplifies DB schema maintenance
    Maxo.Conf.add_relation!(conf, "memberships/users_id", "users/id", "o2m")
    Maxo.Conf.add_relation!(conf, "memberships/teams_id", "teams/id", "o2m")

    res = Maxo.Conf.get_conf(conf)
    # IO.inspect("STOPPPING PID #{inspect(conf)}")
    Maxo.Conf.stop(conf)
    res
  end
end
