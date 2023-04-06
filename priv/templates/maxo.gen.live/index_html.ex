defmodule <%= inspect Module.concat([context.web_module, schema.web_namespace, schema.alias]) %>Live.IndexHtml do
  use <%= inspect context.web_module %>, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <CC.header>
      Listing <%= schema.human_plural %>
      <:actions>
        <PhxC.link patch={~p"<%= schema.route_prefix %>/new"}>
          <CC.button>New <%= schema.human_singular %></CC.button>
        </PhxC.link>
      </:actions>
    </CC.header>

    <CC.table
      id="<%= schema.plural %>"
      rows={@streams.<%= schema.collection %>}
      row_click={fn {_id, <%= schema.singular %>} -> JS.navigate(~p"<%= schema.route_prefix %>/#{<%= schema.singular %>}") end}
    ><%= for {k, _} <- schema.attrs do %>
      <:col :let={{_id, <%= schema.singular %>}} label="<%= Maxo.Naming.humanize(Atom.to_string(k)) %>"><%%= <%= schema.singular %>.<%= k %> %></:col><% end %>
      <:action :let={{_id, <%= schema.singular %>}}>
        <div class="sr-only">
          <PhxC.link navigate={~p"<%= schema.route_prefix %>/#{<%= schema.singular %>}"}>Show</PhxC.link>
        </div>
        <PhxC.link patch={~p"<%= schema.route_prefix %>/#{<%= schema.singular %>}/edit"}>Edit</PhxC.link>
      </:action>
      <:action :let={{id, <%= schema.singular %>}}>
        <PhxC.link
          phx-click={JS.push("delete", value: %{id: <%= schema.singular %>.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </PhxC.link>
      </:action>
    </CC.table>

    <CC.modal :if={@live_action in [:new, :edit]} id="<%= schema.singular %>-modal" show on_cancel={JS.patch(~p"<%= schema.route_prefix %>")}>
      <PhxC.live_component
        module={<%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.FormComponent}
        id={@<%= schema.singular %>.id || :new}
        title={@page_title}
        action={@live_action}
        <%= schema.singular %>={@<%= schema.singular %>}
        patch={~p"<%= schema.route_prefix %>"}
      />
    </CC.modal>
    """
  end
end
