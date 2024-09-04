defmodule OPATest.Plug.Authz do
  # use OPA.ConnCase
  use ExUnit.Case
  use Plug.Test

  require Logger
  alias OPA.Plug.Authz

  setup_all do
    {:ok, pid} = OPATest.Utils.ensure_opa()
    {:ok, _} = OPATest.Utils.seed_opa()
    {:ok, pid: pid}
  end

  @opts Authz.init(package: "example", rule: "allow")

  test "anonymous user is forbidden", %{pid: _pid} do
    conn = conn(:get, "/") |> Authz.call(@opts)

    assert conn.halted
    assert conn.status == 403
  end

  test "bob is forbidden", %{pid: _pid} do
    conn = conn(:get, "/")

    conn =
      assign(conn, :current_user, "bob")
      |> Authz.call(@opts)

    assert conn.halted
    assert conn.status == 403
  end

  test "alice is permitted", %{pid: _pid} do
    conn = conn(:get, "/")

    conn =
      assign(conn, :current_user, "alice")
      |> Authz.call(@opts)

    refute(conn.halted)
  end
end
