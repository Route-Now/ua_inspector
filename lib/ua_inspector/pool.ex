defmodule UAInspector.Pool do
  @moduledoc """
  Connects the plain UAInspector interface with the underlying pool.
  """

  alias UAInspector.Result

  @pool_name :ua_inspector_pool
  @pool_options [
    name: {:local, @pool_name},
    worker_module: UAInspector.Pool.Worker,
    size: 5,
    max_overflow: 10
  ]

  @doc """
  Returns poolboy child specification for supervision tree.
  """
  @spec child_spec :: Supervisor.Spec.spec()
  def child_spec do
    opts =
      @pool_options
      |> Keyword.merge(Application.get_env(:ua_inspector, :pool, []))

    :poolboy.child_spec(@pool_name, opts, [])
  end

  @doc """
  Sends a bot check request to a pool worker.
  """
  @spec bot?(String.t()) :: boolean
  def bot?(nil), do: false
  def bot?(""), do: false

  def bot?(ua) do
    :poolboy.transaction(@pool_name, &GenServer.call(&1, {:is_bot, ua}))
  end

  @doc """
  Sends a HbbTV check request to a pool worker..
  """
  @spec hbbtv?(String.t()) :: false | String.t()
  def hbbtv?(nil), do: false
  def hbbtv?(""), do: false

  def hbbtv?(ua) do
    :poolboy.transaction(@pool_name, &GenServer.call(&1, {:is_hbbtv, ua}))
  end

  @doc """
  Sends a parse request to a pool worker.
  """
  @spec parse(String.t()) :: map
  def parse(nil), do: %Result{user_agent: nil}
  def parse(""), do: %Result{user_agent: ""}

  def parse(ua) do
    :poolboy.transaction(@pool_name, &GenServer.call(&1, {:parse, ua}))
  end

  @doc """
  Sends a client parse request to a pool worker.
  """
  @spec parse_client(String.t()) :: map
  def parse_client(nil), do: %Result{user_agent: nil}
  def parse_client(""), do: %Result{user_agent: ""}

  def parse_client(ua) do
    :poolboy.transaction(@pool_name, &GenServer.call(&1, {:parse_client, ua}))
  end
end
