defmodule Veryapp.Web.ProductLiveRouting do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      alias Veryapp.Web.ProductLive

      live "/products", ProductLive.Index, :index
      live "/products/new", ProductLive.Index, :new
      live "/products/:id/edit", ProductLive.Index, :edit

      live "/products/:id", ProductLive.Show, :show
      live "/products/:id/show/edit", ProductLive.Show, :edit
    end
  end
end
