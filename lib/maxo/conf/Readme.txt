## Configuration for Maxo

Because we want to configure the full application in a single config, this needs more logic.


## API
{:ok, conf} = Maxo.Conf.Server.start_link()

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
Maxo.Conf.add_field!(conf, "memberships", %{name: "users_id", type: "integer", nullable: false})
Maxo.Conf.add_field!(conf, "memberships", %{name: "teams_id", type: "integer", nullable: false})
Maxo.Conf.unique_index!(conf, "memberships", ["users_id"])
Maxo.Conf.unique_index!(conf, "memberships", ["teams_id"])

## relations can be executed after all tables, that simplified DB schema maintenance
Maxo.Conf.add_relation!(conf, :o2m, %{src: "memberships", src_field: "users_id", dest: "users", dest_field: "id"})
Maxo.Conf.add_relation!(conf, :o2m, %{src: "memberships", src_field: "teams_id", dest: "teams", dest_field: "id"})


Maxo.Conf.add_table(conf, "tags")
Maxo.Conf.add_field(conf, "tags", %{name: "name", type: "string", nullable: false})
Maxo.Conf.add_field(conf, "tags", %{name: "color", type: "string", nullable: false})

Maxo.Conf.add_table(conf, "taggings")
Maxo.Conf.add_field(conf, "taggings", %{name: "tag_id", type: "integer", nullable: false})
Maxo.Conf.add_field(conf, "taggings", %{name: "taggable_id", type: "integer", nullable: false})
Maxo.Conf.add_field(conf, "taggings", %{name: "taggable_type", type: "string", nullable: false})
