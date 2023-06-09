defmodule Maxo.Conf do
  use GenServer
  alias Maxo.Conf.State
  alias Maxo.Conf.Backend

  @impl true
  def init(state) do
    {:ok, state}
  end

  ###
  ### API
  ###

  def start_link() do
    start_link(Backend.init())
  end

  def stop(pid) do
    Process.exit(pid, :normal)
  end

  def start_link(%State{} = backend) do
    GenServer.start_link(__MODULE__, backend)
  end

  def add_context(pid, name, comment \\ "") do
    GenServer.call(pid, {:add_context, name, comment})
  end

  def add_context!(pid, name, comment \\ "") do
    handle_error(add_context(pid, name, comment), {:add_context!, name, comment})
  end

  def add_table(pid, name, comment \\ "") do
    GenServer.call(pid, {:add_table, name, comment})
  end

  def add_table!(pid, name, comment \\ "") do
    handle_error(add_table(pid, name, comment), {:add_table!, name, comment})
  end

  def add_column(pid, name, args) do
    GenServer.call(pid, {:add_column, name, args})
  end

  def add_column!(pid, name, args) do
    handle_error(add_column(pid, name, args), {:add_column!, name, args})
  end

  def add_relation(pid, src, dest, cardinality \\ "o2m") do
    GenServer.call(pid, {:add_relation, src, dest, cardinality})
  end

  def add_relation!(pid, src, dest, cardinality \\ "o2m") do
    handle_error(
      add_relation(pid, src, dest, cardinality),
      {:add_relation!, src, dest, cardinality}
    )
  end

  def add_index(pid, table, columns, opts \\ []) do
    GenServer.call(pid, {:add_index, table, columns, opts})
  end

  def add_index!(pid, table, columns, opts \\ []) do
    handle_error(
      add_index(pid, table, columns, opts),
      {:add_index!, table, columns, opts}
    )
  end

  def get_conf(pid) do
    GenServer.call(pid, {:get_conf})
  end

  def set_conf(pid, conf) do
    GenServer.call(pid, {:set_conf, conf})
  end

  ###
  ### GEN SERVER CALLBACKS
  ###

  @impl true
  def handle_call({:add_context, name, comment}, _from, %State{} = state) do
    {state, res} = Backend.add_context(state, name, comment)
    {:reply, res, state}
  end

  @impl true
  def handle_call({:add_table, name, comment}, _from, %State{} = state) do
    {state, res} = Backend.add_table(state, name, comment)
    {:reply, res, state}
  end

  @impl true
  def handle_call({:add_column, name, args}, _from, %State{} = state) do
    {state, res} = Backend.add_column(state, name, args)
    {:reply, res, state}
  end

  @impl true
  def handle_call({:add_relation, src, dest, cardinality}, _from, %State{} = state) do
    {state, res} = Backend.add_relation(state, src, dest, cardinality)
    {:reply, res, state}
  end

  @impl true
  def handle_call({:add_index, table, columns, opts}, _from, %State{} = state) do
    {state, res} = Backend.add_index(state, table, columns, opts)
    {:reply, res, state}
  end

  ### Management / Debug
  @impl true
  def handle_call({:get_conf}, _from, %State{} = state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:set_conf, %State{} = conf}, _from, %State{} = _state) do
    {:reply, :ok, conf}
  end

  defp handle_error(res, args) do
    case res do
      {:error, _} -> raise(inspect({res, args}))
      {:ok, res} -> res
      :ok -> :ok
    end
  end
end
