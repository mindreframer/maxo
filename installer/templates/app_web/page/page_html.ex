defmodule <%= @app_module  %>.Page.PageHTML do
  use <%= @web_namespace %>, :html

  embed_templates "page_html/*"
end
