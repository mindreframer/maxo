defmodule Maxo.Files.State do
  defstruct(lines: [], indent: 0, prefix: "")
end

defmodule Maxo.Files.FileWriter do
  alias Maxo.Files.State
  use(GenServer)
  @init_state %State{}

  def start_link() do
    start_link(@init_state)
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(state = %State{}) do
    {:ok, state}
  end

  ## API

  def put(pid, line) do
    GenServer.call(pid, {:put, line})
  end

  def put(pid, line, indent) do
    GenServer.call(pid, {:put, line, indent})
  end

  def indent_up(pid, amount \\ 2) do
    GenServer.call(pid, {:indent_up, amount})
  end

  def indent_down(pid, amount \\ 2) do
    GenServer.call(pid, {:indent_down, amount})
  end

  def content(pid) do
    GenServer.call(pid, {:content})
  end

  def get_indent(pid) do
    GenServer.call(pid, {:get_indent})
  end

  def with_indent(pid, fun, amount \\ 2) do
    indent_up(pid, amount)
    fun.()
    indent_down(pid, amount)
  end

  # def dump(pid, path) do
  # end

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
  def handle_call({:set_indent, indent}, _from, %State{} = state) when is_number(indent) do
    state = %State{state | indent: indent}
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:indent_up, amount}, _from, %State{} = state) when is_number(amount) do
    state = %State{state | indent: state.indent + amount}
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:indent_down, amount}, _from, %State{} = state) when is_number(amount) do
    state = %State{state | indent: max(state.indent - amount, 0)}
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:get_indent}, _from, %State{} = state) do
    {:reply, state.indent, state}
  end

  defp indented(line, indent) do
    ~s|#{String.duplicate(" ", indent)}#{line}|
  end
end
