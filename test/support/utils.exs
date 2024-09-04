defmodule OPATest.Utils do
  def ensure_opa do
    Application.put_env(:opa, :endpoint, "http://localhost:8282")
    {:ok, pid} = OPA.Server.HttpListener.start_link(addr: "localhost:8282")

    GenServer.call(pid, :ping)
    {:ok, pid}
  end

  def seed_opa do
    endpoint = Application.get_env(:opa, :endpoint, "http://localhost:8181")

    Req.put(
      url: "#{endpoint}/v1/policies/example",
      body: File.read!("test/policies/example.rego")
    )
  end
end
