defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.ShowHtml do
  use <%= inspect context.web_module %>, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <CC.header>
      <%= schema.human_singular %> <%%= @<%= schema.singular %>.id %>
      <:subtitle>This is a <%= schema.singular %> record from your database.</:subtitle>
      <:actions>
        <PhxC.link patch={~p"<%= schema.route_prefix %>/#{@<%= schema.singular %>}/show/edit"} phx-click={JS.push_focus()}>
          <CC.button>Edit <%= schema.singular %></CC.button>
        </PhxC.link>
      </:actions>
    </CC.header>

    <CC.list><%= for {k, _} <- schema.attrs do %>
      <:item title="<%= Maxo.Naming.humanize(Atom.to_string(k)) %>"><%%= @<%= schema.singular %>.<%= k %> %></:item><% end %>
    </CC.list>

    <CC.back navigate={~p"<%= schema.route_prefix %>"}>Back to <%= schema.plural %></CC.back>

    <CC.modal :if={@live_action == :edit} id="<%= schema.singular %>-modal" show on_cancel={JS.patch(~p"<%= schema.route_prefix %>/#{@<%= schema.singular %>}")}>
      <PhxC.live_component
        module={<%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.FormComponent}
        id={@<%= schema.singular %>.id}
        title={@page_title}
        action={@live_action}
        <%= schema.singular %>={@<%= schema.singular %>}
        patch={~p"<%= schema.route_prefix %>/#{@<%= schema.singular %>}"}
      />
    </CC.modal>
    """
  end
end
