defmodule MaxoNew.Virtfs.Mix.Generator do
  @moduledoc """
  Conveniences for working with paths and generating content.
  """
  alias MaxoNew.Virtfs

  @doc ~S"""
  Creates a file with the given contents.

  If the file already exists and the contents are not the same,
  it asks for user confirmation.

  ## Options

    * `:force` - forces creation without a shell prompt
    * `:quiet` - does not log command output

  ## Examples

      iex> MaxoNew.Virtfs.Mix.Generator.create_file(fs, ".gitignore", "_build\ndeps\n")
      * creating .gitignore
      true

  """

  @spec create_file(pid, Path.t(), iodata, keyword) :: boolean()
  def create_file(fs, path, contents, opts \\ []) when is_binary(path) do
    log(:green, :creating, path, opts)

    if opts[:force] || overwrite?(fs, path, contents) do
      Virtfs.mkdir_p!(fs, Path.dirname(path))
      Virtfs.write!(fs, path, contents)
      true
    else
      false
    end
  end

  @doc """
  Creates a directory if one does not exist yet.

  This function does nothing if the given directory already exists; in this
  case, it still logs the directory creation.

  ## Options

    * `:quiet` - does not log command output

  ## Examples

      iex> MaxoNew.Virtfs.Mix.Generator.create_directory(fs, "path/to/dir")
      * creating path/to/dir
      true

  """
  @spec create_directory(pid, Path.t(), keyword) :: true
  def create_directory(fs, path, options \\ []) when is_binary(path) do
    cwd = Virtfs.cwd(fs)
    log(:green, "creating", Path.relative_to(cwd, path), options)
    Virtfs.mkdir_p!(fs, path)
    true
  end

  @doc ~S"""
  Copies `source` to `target`.

  If `target` already exists and the contents are not the same,
  it asks for user confirmation.

  ## Options

    * `:force` - forces copying without a shell prompt
    * `:quiet` - does not log command output

  ## Examples

      iex> MaxoNew.Virtfs.Mix.Generator.copy_file(fs, "source/gitignore", ".gitignore")
      * creating .gitignore
      true

  """
  @doc since: "1.9.0"
  @spec copy_file(pid, Path.t(), Path.t(), keyword) :: boolean()
  def copy_file(fs, source, target, options \\ []) do
    create_file(target, Virtfs.read!(fs, source), options)
  end

  @doc ~S"""
  Evaluates and copy templates at `source` to `target`.

  The template in `source` is evaluated with the given `assigns`.

  If `target` already exists and the contents are not the same,
  it asks for user confirmation.

  ## Options

    * `:force` - forces copying without a shell prompt
    * `:quiet` - does not log command output

  ## Examples

      iex> assigns = [project_path: "/Users/joe/newproject"]
      iex> MaxoNew.Virtfs.Mix.Generator.copy_template("source/gitignore", ".gitignore", assigns)
      * creating .gitignore
      true

  """
  @doc since: "1.9.0"
  @spec copy_template(pid, Path.t(), Path.t(), keyword, keyword) :: boolean()
  def copy_template(fs, source, target, assigns, options \\ []) do
    create_file(fs, target, EEx.eval_file(source, assigns: assigns), options)
  end

  @doc """
  Prompts the user to overwrite the file if it exists.

  Returns false if the file exists and the user forbade
  to override it. Returns true otherwise.
  """
  @doc since: "1.9.0"
  @spec overwrite?(pid, Path.t()) :: boolean
  def overwrite?(fs, path) do
    if Virtfs.exists?(fs, path) do
      full = Virtfs.expand(fs, path)
      Mix.shell().yes?(Virtfs.relative_to_cwd(fs, full) <> " already exists, overwrite?")
    else
      true
    end
  end

  @doc """
  Prompts the user to overwrite the file if it exists.

  The contents are compared to avoid asking the user to
  override if the contents did not change. Returns false
  if the file exists and the content is the same or the
  user forbade to override it. Returns true otherwise.
  """
  @doc since: "1.9.0"
  @spec overwrite?(pid, Path.t(), iodata) :: boolean
  def overwrite?(fs, path, contents) do
    case Virtfs.read(fs, path) do
      {:ok, binary} ->
        if binary == IO.iodata_to_binary(contents) do
          false
        else
          full = Virtfs.expand(fs, path)
          Mix.shell().yes?(Virtfs.relative_to_cwd(fs, full) <> " already exists, overwrite?")
        end

      _ ->
        true
    end
  end

  defp log(color, command, message, opts) do
    unless opts[:quiet] do
      Mix.shell().info([color, "* #{command} ", :reset, message])
    end
  end
end
