defmodule OPA.Plug.Authz do
  require Logger

  import Plug.Conn

  def init([package: _package, rule: _rule] = opts), do: opts
  def init(_), do: {:error, "must configure package and rule"}

  def call(%Plug.Conn{} = conn, [package: package, rule: rule] = opts) do
    with opa_req <- conn_to_opa_req(conn, opts),
         {:ok, opa_resp} <- OPA.Client.query(package, rule, opa_req) do
      handle_opa_resp(conn, opa_resp)
    else
      {:error, error} ->
        Logger.error(error)

        conn
        |> send_resp(500, "internal server error")
        |> halt

      error ->
        Logger.error(error)

        conn
        |> send_resp(500, "internal server error")
        |> halt
    end
  end

  def call(%Plug.Conn{} = conn, _) do
    conn
    |> send_resp(500, "internal server error")
    |> halt
  end

  defp handle_opa_resp(conn, %{"result" => false}) do
    conn
    |> send_resp(403, "unauthorized")
    |> halt()
  end

  defp handle_opa_resp(conn, %{"result" => true}) do
    conn
  end

  defp handle_opa_resp(conn, opa_result) do
    Logger.error("unexpected opa result: #{inspect(opa_result)}")

    conn
    |> send_resp(500, "internal server error")
    |> halt()
  end

  defp conn_to_opa_req(conn, _opts) do
    path =
      conn.request_path
      |> String.trim()
      |> String.split("/")

    current_user = conn.assigns[:current_user]

    %{
      method: conn.method,
      path: path,
      query_params: conn.query_params,
      body: conn.body_params,
      user: current_user
    }
  end
end
