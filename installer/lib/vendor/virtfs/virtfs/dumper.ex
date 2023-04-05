defmodule MaxoNew.Virtfs.Dumper do
  def run(%MaxoNew.Virtfs.FS{} = fs, dest) do
    files = fs.files
    Enum.each(files, &create_file(dest, elem(&1, 1)))
  end

  def create_file(dest, %MaxoNew.Virtfs.File{kind: :dir, path: path}) do
    full_path = full_path(dest, path)
    File.mkdir_p!(full_path)
  end

  def create_file(dest, %MaxoNew.Virtfs.File{kind: :file, content: content, path: path}) do
    full_path = full_path(dest, path)
    dir_path = Path.dirname(full_path)
    File.mkdir_p!(dir_path)
    File.write!(full_path, content)
  end

  def full_path(dest, path) do
    Path.join(dest, path)
  end
end
