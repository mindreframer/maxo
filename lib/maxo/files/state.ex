defmodule Maxo.Files.State do
  defstruct(
    lines: [],
    indent: 0,
    dumper: {__MODULE__, :dummy_dump}
  )

  def dummy_dump(path, content) do
    IO.puts("********************************** DUMP ************************************")
    IO.puts("dumping to #{path}")
    IO.puts(content)

    IO.puts(
      "********************************** DUMP FINISHED ************************************"
    )
  end
end
