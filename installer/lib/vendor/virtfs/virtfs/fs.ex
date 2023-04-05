defmodule MaxoNew.Virtfs.FS do
  alias MaxoNew.Virtfs.FS
  use MaxoNew.TypedStruct

  typedstruct do
    @typedoc "Virtual Filesystem"

    field(:cwd, String.t(), default: "/")
    field(:files, map())
  end

  def init(opts \\ []) do
    path = Keyword.get(opts, :path, "/")

    %FS{
      files: %{
        "/" => MaxoNew.Virtfs.File.new_dir("/")
      },
      cwd: path
    }
  end
end
