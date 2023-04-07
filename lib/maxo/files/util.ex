defmodule Maxo.Files.Util do
  @rootpath Path.join([Path.dirname(__ENV__.file), "..", ".."]) |> Path.expand()
  def rootpath do
    @rootpath
  end

  def with_root(file) do
    Path.join(@rootpath, file)
  end

  def with_outpath(file) do
    with_root(Path.join("priv/out", file))
  end
end
