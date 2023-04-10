defmodule Maxo.Files.Check do
  alias Maxo.Files.FileWriter, as: FW

  def run do
    {:ok, pid} = FW.start_link()
    # FW.reset(pid)
    FW.put(pid, "defmodule Hey do")
    FW.put(pid, "## Hello here!", 2)
    FW.put(pid, ~s|@moduledoc "something about this module"|, 2)
    FW.put(pid, "")

    for fun <- ["hello1", "hello2", "hello3"] do
      gen_func(pid, fun)
      FW.put(pid, "")
    end

    FW.put(pid, "end")
    FW.content(pid) |> IO.puts()
    FW.dump(pid, "/some/file.ex")
  end

  defp inner_part(pid) do
    for i <- 0..10 do
      FW.indented(pid, fn ->
        FW.put(pid, ~s|IO.puts "#{i}"|)
      end)
    end
  end

  defp gen_func(pid, fun) do
    FW.indented(pid, fn ->
      FW.put(pid, ~s|@doc "some doc for #{fun}"|)
      FW.put(pid, "def #{fun} do")
      inner_part(pid)
      FW.put(pid, "end")
    end)
  end
end
