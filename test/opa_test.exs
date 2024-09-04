defmodule OPATest do
  use ExUnit.Case
  doctest OPA

  setup_all do
    {:ok, pid} = OPATest.Utils.ensure_opa()
    {:ok, _} = OPATest.Utils.seed_opa()
    {:ok, pid: pid}
  end

  test "alice is authorized" do
    input = %{
      user: "alice",
      action: "GET",
      resource: "data1"
    }

    assert OPA.Client.query("example", "allow", input) == {:ok, %{"result" => true}}
  end

  test "bob is unauthorized" do
    input = %{
      user: "bob",
      action: "GET",
      resource: "data1"
    }

    assert OPA.Client.query("example", "allow", input) == {:ok, %{"result" => false}}
  end

  test "a missing policy results in an empty response" do
    input = %{
      user: "alice",
      action: "GET",
      resource: "data2"
    }

    assert OPA.Client.query("example", "missing", input) == {:ok, %{}}
  end
end
