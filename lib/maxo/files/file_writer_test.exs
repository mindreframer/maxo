defmodule Maxo.Files.FileWriterTest do
  use ExUnit.Case, async: true
  use MnemeDefaults

  alias Maxo.Files.FileWriter, as: FW

  describe "full" do
    test "works" do
      {:ok, pid} = FW.start_link()
      FW.put(pid, ~s|## Hello|)
      FW.put(pid, ~s|defmodule Hey do|)

      FW.with_indent(pid, fn ->
        FW.put(pid, ~s|def hello do|)
        FW.indent_up(pid, 2)
        FW.put(pid, ~s|IO.puts "hello"|)
        FW.indent_down(pid, 2)
        FW.with_indent(pid, 2, fn -> FW.put(pid, ~s|IO.puts "hello"|) end)
        FW.put(pid, ~s|end|)
      end)

      FW.put(pid, ~s|end|)

      auto_assert(
        """
        ## Hello
        defmodule Hey do
          def hello do
            IO.puts "hello"
            IO.puts "hello"
          end
        end\
        """ <- FW.content(pid)
      )
    end
  end
end
