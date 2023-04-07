defmodule Maxo.Conf.Naming do
  def column(table, column) do
    "#{table}/#{column}"
  end
end
