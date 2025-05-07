defmodule OPATest.Utils do
  def ensure_opa do
    Application.put_env(:opa, :endpoint, "http://localhost:8282")
    {:ok, pid} = OPA.Server.HttpListener.start_link(addr: "localhost:8282")

    poll_for_opa_server()
    {:ok, pid}
  end

  def poll_for_opa_server(retries \\ 10) do
    case retries do
      0 ->
        {:error, "OPA server not available"}

      _ ->
        case OPA.Server.HttpListener.ping() do
          {:ok, _} ->
            :ok

          {:error, _} ->
            Process.sleep(500)
            poll_for_opa_server(retries - 1)
        end
    end
  end

  def seed_opa do
    endpoint = Application.get_env(:opa, :endpoint, "http://localhost:8282")

    Req.put(
      url: "#{endpoint}/v1/policies/example",
      body: File.read!("test/policies/example.rego")
    )
  end
end
