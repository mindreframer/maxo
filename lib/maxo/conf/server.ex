defmodule Maxo.Conf.Server do
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

  def add_field(pid, name, args) do
    GenServer.call(pid, {:add_field, name, args})
  end

  def add_field!(pid, name, args) do
    handle_error(add_field(pid, name, args), {:add_field!, name, args})
  end

  def get_conf(pid) do
    GenServer.call(pid, {:get_conf})
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
  def handle_call({:add_field, name, args}, _from, %State{} = state) do
    {state, res} = Backend.add_field(state, name, args)
    {:reply, res, state}
  end

  ### Management / Debug
  @impl true
  def handle_call({:get_conf}, _from, %State{} = state) do
    {:reply, state, state}
  end

  defp handle_error(res, args) do
    case res do
      {:error, _} -> raise(inspect({res, args}))
      {:ok, res} -> res
      :ok -> :ok
    end
  end
end
