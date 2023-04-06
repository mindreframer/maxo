defmodule Veryapp.Web.CategoryLiveRouting do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      alias Veryapp.Web.CategoryLive

      live "/categories", CategoryLive.Index, :index
      live "/categories/new", CategoryLive.Index, :new
      live "/categories/:id/edit", CategoryLive.Index, :edit

      live "/categories/:id", CategoryLive.Show, :show
      live "/categories/:id/show/edit", CategoryLive.Show, :edit
    end
  end
end
