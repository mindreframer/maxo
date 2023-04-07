defmodule Maxo.Files.FileWriter do
  @moduledoc """
  A small server to accumulate lines and dump them to a file quickly
  """

  alias Maxo.Files.FileReader

  @name __MODULE__
  use Agent
  def start_link(), do: start_link([])

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: @name)
  end

  def get() do
    Agent.get(@name, fn content -> content |> Enum.reverse() end)
  end

  # noop for nil
  def put(nil) do
    nil
  end

  def put(line) do
    Agent.update(@name, fn content -> [line | content] end)
  end

  # reading for files with scope to taxml2clips folder
  def put_file(filename) do
    put("# >>> FROM #{filename}")
    put(FileReader.read!(filename))
    put("# >>> DONE #{filename}")
    put("# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n")
  end

  def dump(file) do
    # assert the folder exists
    File.mkdir_p(Path.dirname(file))
    # empty the file first
    File.write(file, "")

    File.open(file, [:write, :utf8], fn file ->
      Enum.each(get(), fn line ->
        IO.puts(file, line)
      end)
    end)
  end

  def reset() do
    Agent.update(@name, fn _content -> [] end)
  end
end
