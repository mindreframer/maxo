defmodule <%= inspect schema.live_routing_module %> do
  <% 
    url_prefix = schema.plural 
    live_mod = "#{inspect(schema.alias)}Live"
    to_alias = Module.concat([context.web_module, schema.web_namespace, "#{schema.alias}Live"])
  %>
  defmacro __using__(_) do
    quote do
      alias <%= inspect(to_alias) %>

      live "/<%= url_prefix %>", <%= live_mod %>.Index, :index
      live "/<%= url_prefix %>/new", <%= live_mod %>.Index, :new
      live "/<%= url_prefix %>/:id/edit", <%= live_mod %>.Index, :edit

      live "/<%= url_prefix %>/:id", <%= live_mod %>.Show, :show
      live "/<%= url_prefix %>/:id/show/edit", <%= live_mod %>.Show, :edit
    end
  end
end
