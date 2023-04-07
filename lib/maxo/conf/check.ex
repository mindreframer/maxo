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
    Maxo.Conf.add_field!(conf, "users", %{name: "name", type: "string", nullable: false})
    Maxo.Conf.add_field!(conf, "users", %{name: "email", type: "string", nullable: false})
    Maxo.Conf.add_field!(conf, "users", %{name: "password_hash", type: "string", nullable: false})

    Maxo.Conf.add_table!(conf, "teams")
    Maxo.Conf.add_field!(conf, "teams", %{name: "name", type: "string", nullable: false})

    Maxo.Conf.add_table!(conf, "memberships")
    Maxo.Conf.add_field!(conf, "memberships", %{name: "users_id", type: "int", nullable: false})
    Maxo.Conf.add_field!(conf, "memberships", %{name: "teams_id", type: "int", nullable: false})
    res = Maxo.Conf.get_conf(conf)
    # IO.inspect("STOPPPING PID #{inspect(conf)}")
    Maxo.Conf.stop(conf)
    res
  end
end
