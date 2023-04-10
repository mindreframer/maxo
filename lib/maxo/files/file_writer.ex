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

defmodule Maxo.Files.FileWriter do
  alias Maxo.Files.State
  use GenServer
  @init_state %State{}

  def start_link(), do: start_link(@init_state)
  def start_link(state), do: GenServer.start_link(__MODULE__, state)

  @impl true
  def init(state = %State{}), do: {:ok, state}

  ## API
  def put(pid, line), do: call(pid, {:put, line})
  def put(pid, line, indent), do: call(pid, {:put, line, indent})
  def content(pid), do: call(pid, {:content})
  def reset(pid), do: call(pid, {:reset})

  ## Dumping
  def dump(pid, path), do: call(pid, {:dump, path})
  def set_dumper(pid, dumper), do: call(pid, {:set_dumper, dumper})

  ## Indenting
  def get_indent(pid), do: call(pid, {:get_indent})
  def indent_up(pid, amount \\ 2), do: call(pid, {:indent_up, amount})
  def indent_down(pid, amount \\ 2), do: call(pid, {:indent_down, amount})
  def with_indent(pid, fun), do: with_indent(pid, fun, 2)
  def with_indent(pid, amount, fun) when is_number(amount), do: with_indent(pid, fun, amount)

  def with_indent(pid, fun, amount) do
    indent_up(pid, amount)
    fun.()
    indent_down(pid, amount)
  end

  ## CALLBACKS

  @impl true
  def handle_call({:put, line}, _from, %State{} = state) do
    handle_call({:put, line, state.indent}, nil, state)
  end

  @impl true
  def handle_call({:put, line, indent}, _from, %State{} = state) do
    state = %State{state | lines: [indented(line, indent) | state.lines]}
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:content}, _from, %State{} = state) do
    content = state.lines |> Enum.reverse() |> Enum.join("\n")
    {:reply, content, state}
  end

  @impl true
  def handle_call({:reset}, _from, %State{} = _state) do
    {:reply, :ok, @init_state}
  end

  @impl true
  def handle_call({:dump, path}, _from, %State{dumper: {mod, fun}} = state) do
    res = apply(mod, fun, [path, to_content(state)])
    {:reply, res, state}
  end

  @impl true
  def handle_call({:dump, path}, _from, %State{dumper: dumper_fun} = state)
      when is_function(dumper_fun, 2) do
    res = dumper_fun.(path, to_content(state))
    {:reply, res, state}
  end

  @impl true
  def handle_call({:set_indent, indent}, _from, %State{} = state) when is_number(indent) do
    state = put_indent(state, indent)
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:indent_up, amount}, _from, %State{} = state) when is_number(amount) do
    state = put_indent(state, state.indent + amount)
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:indent_down, amount}, _from, %State{} = state) when is_number(amount) do
    state = put_indent(state, max(state.indent - amount, 0))
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:get_indent}, _from, %State{} = state) do
    {:reply, state.indent, state}
  end

  ###
  ### Internal helpers
  ###
  defp call(pid, args) do
    GenServer.call(pid, args)
  end

  defp put_indent(state, indent) do
    %State{state | indent: indent}
  end

  defp indented(line, indent) do
    ~s|#{String.duplicate(" ", indent)}#{line}|
  end

  defp to_content(%State{} = state) do
    state.lines |> Enum.reverse() |> Enum.join("\n")
  end
end
