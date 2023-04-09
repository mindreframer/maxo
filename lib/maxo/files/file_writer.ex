defmodule Maxo.Files.FileWriter do
  @moduledoc """
  A small server to accumulate lines and dump them to a file quickly
  """

  alias Maxo.Files.FileReader

  @initial %{lines: [], indent: 0}

  @name __MODULE__
  use Agent
  def start_link(), do: start_link(@initial)

  def start_link(opts) do
    Agent.start_link(fn -> opts end, name: @name)
  end

  def get() do
    Agent.get(@name, fn %{lines: lines} -> lines |> Enum.reverse() end)
  end

  def content() do
    get() |> Enum.join("\n")
  end

  # noop for nil
  def put(nil) do
    nil
  end

  def put(line) do
    Agent.update(@name, fn state ->
      %{state | lines: [indented(line, state.indent) | state.lines]}
    end)
  end

  def put(line, indent) when is_number(indent) do
    Agent.update(@name, fn state ->
      %{state | lines: [indented(line, indent) | state.lines]}
    end)
  end

  def get_indent() do
    Agent.get(@name, fn %{indent: indent} -> indent end)
  end

  def set_indent(indent) do
    Agent.update(@name, fn state -> %{state | indent: indent} end)
  end

  def with_indent(indent, fun) do
    orig = get_indent()
    set_indent(orig + indent)
    fun.()
    set_indent(orig)
  end

  # reading for files with scope to taxml2clips folder
  def put_file(filename, commentchar \\ "#") do
    put("#{commentchar} >>> FROM #{filename}")
    put(FileReader.read!(filename))
    put("#{commentchar} >>> DONE #{filename}")

    put(
      "#{commentchar} >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
    )
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
    Agent.update(@name, fn _content -> @initial end)
  end

  defp indented(line, indent) do
    ~s|#{String.duplicate(" ", indent)}#{line}|
  end
end
