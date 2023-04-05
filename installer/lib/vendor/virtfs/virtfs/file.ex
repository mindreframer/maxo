defmodule MaxoNew.Virtfs.File do
  @type kind :: :file | :dir

  use MaxoNew.TypedStruct

  typedstruct do
    @typedoc "A File"

    field(:kind, kind, default: :file)
    field(:content, String.t(), default: "")
    field(:path, String.t(), enforce: true)
  end

  def new_file(path, content) do
    %MaxoNew.Virtfs.File{
      kind: :file,
      path: path,
      content: content
    }
  end

  def new_dir(path) do
    %MaxoNew.Virtfs.File{
      kind: :dir,
      path: path
    }
  end
end
