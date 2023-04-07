defmodule Maxo.Files.Check do
  alias Maxo.Files.FileWriter, as: FW

  def run do
    FW.start_link()
    FW.reset()
    FW.put("## Hello here!")
    FW.put("defmodule Hey do")

    FW.with_indent(2, fn ->
      FW.put("def hello do")

      FW.with_indent(2, fn ->
        FW.put(~s|IO.puts "42"|)
      end)

      FW.put("end")
    end)

    FW.put("end")

    FW.get()
  end
end
