defmodule Maxo.Files.FileWriter2 do
  use GenServer
  defmodule State, do: defstruct(lines: [], indent: 0)

  def start_link() do
    start_link(%State{})
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

  def content(pid) do
    GenServer.call(pid, {:content})
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
    {:reply, :ok, %State{}}
  end

  defp indented(line, indent) do
    ~s|#{String.duplicate(" ", indent)}#{line}|
  end
end
