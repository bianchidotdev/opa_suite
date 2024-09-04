defmodule OPA.Server.HttpListener do
  use GenServer
  require Logger

  def start_link(options) do
    {opa_cli, options} = Keyword.pop(options, :opa_cli, System.find_executable("opa"))
    {addr, options} = Keyword.pop(options, :addr, "localhost:8181")

    options = Keyword.validate!(options, [:name, :timeout, :debug, :spawn_opt, :hibernate_after])

    GenServer.start_link(
      __MODULE__,
      %{opa_cli: opa_cli, addr: addr},
      options
    )
  end

  def ping() do
    GenServer.call(__MODULE__, :ping)
  end

  @impl true
  def init(%{opa_cli: nil}) do
    Logger.warning("""
    OPA CLI not found

    Run:
        brew install opa
    """)

    :ignore
  end

  def init(%{opa_cli: opa_cli, addr: addr}) do
    args =
      [
        "run",
        "--server",
        "--addr",
        addr
      ]

    port =
      Port.open(
        {:spawn_executable, opa_cli},
        [
          :binary,
          :stderr_to_stdout,
          line: 2048,
          args: args
        ]
      )

    receive do
      {^port, {:data, {:eol, line}}} ->
        Logger.debug(line, domain: [:opa])
    end

    {:ok, port}
  end

  @impl true
  def handle_call(:ping, _from, port) do
    {:reply, :ok, port}
  end

  @impl true
  def handle_call(:close, _from, port) do
    Port.close(port)
    {:stop, :normal, :ok, port}
  end

  @impl true
  def handle_info({port, {:data, {:eol, line}}}, port) do
    Logger.debug(line, domain: [:opa])
    {:noreply, port}
  end
end
