defmodule Veryapp.Web.StickLiveRouting do
  @moduledoc false
  
  defmacro __using__(_) do
    quote do
      alias Veryapp.Web.StickLive

      live "/sticks", StickLive.Index, :index
      live "/sticks/new", StickLive.Index, :new
      live "/sticks/:id/edit", StickLive.Index, :edit

      live "/sticks/:id", StickLive.Show, :show
      live "/sticks/:id/show/edit", StickLive.Show, :edit
    end
  end
end
