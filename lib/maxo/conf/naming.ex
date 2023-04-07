defmodule Maxo.Conf.Naming do
  def column(table, column) do
    "#{table}/#{column}"
  end

  def relation(src, dest, cardinality) do
    "#{src} > #{dest} : #{cardinality}"
  end
end
