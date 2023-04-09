defmodule Maxo.Files.Check do
  alias Maxo.Files.FileWriter, as: FW

  def run do
    FW.start_link()
    FW.reset()
    FW.put("defmodule Hey do")
    FW.put("## Hello here!", 2)
    FW.put(~s|@moduledoc "something about this module"|, 2)
    FW.put("")

    for fun <- ["hello1", "hello2", "hello3"] do
      gen_func(fun)
      FW.put("")
    end

    FW.put("end")
    FW.content() |> IO.puts()
  end

  defp inner_part do
    for i <- 0..10 do
      FW.with_indent(2, fn ->
        FW.put(~s|IO.puts "#{i}"|)
      end)
    end
  end

  defp gen_func(fun) do
    FW.with_indent(2, fn ->
      FW.put(~s|@doc "some doc for #{fun}"|)
      FW.put("def #{fun} do")
      inner_part()
      FW.put("end")
    end)
  end
end
