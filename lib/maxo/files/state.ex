defmodule Maxo.Files.State do
  defstruct(
    lines: [],
    indent: 0,
    dumper: {__MODULE__, :dummy_dump}
  )

  def dummy_dump(path, content) do
    IO.puts(banner("DUMP STARTED"))
    IO.puts("dumping to #{path}")
    IO.puts(content)
    IO.puts(banner("DUMP FINISHED"))
  end

  @chars "**********************************"
  defp banner(line) do
    @chars <> " #{line} " <> @chars
  end
end
