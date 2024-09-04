defmodule OPA.Client do
  def new(options \\ []) do
    {endpoint, options} =
      Keyword.pop(
        options,
        :endpoint,
        Application.get_env(:opa, :endpoint, "http://localhost:8181")
      )

    Req.new(base_url: "#{endpoint}/")
    |> Req.merge(options)
  end

  def query(package, rule, input, _options \\ []) do
    with {:ok, response} <-
           Req.post(
             new(url: "/v1/data/#{construct_rule_path(package, rule)}", json: %{input: input})
           ) do
      {:ok, response.body}
    else
      error -> error
    end
  end

  defp construct_rule_path(package, rule) do
    "#{String.replace(package, ".", "/")}/#{rule}"
  end
end
