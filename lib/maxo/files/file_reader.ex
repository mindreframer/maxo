defmodule Maxo.Files.FileReader do
  @moduledoc """
  Consistent file reading from any umbrella application
  """
  alias Maxo.Files.Util

  def read!(file) do
    File.read!(Util.with_root(file))
  end
end
