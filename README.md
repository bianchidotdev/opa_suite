# OPA
OPA (Open Policy Agent) is an Elixir library that provides tools for integrating with OPA. It includes a Plug for easy integration with Phoenix applications, a simple client for making requests to an OPA server, and a server initializer helper to set up an OPA server instance.

## Features

- **Plug Integration**: Easily integrate OPA with your Phoenix applications using the provided Plug.
- **Simple Client**: A straightforward client for making requests to an OPA server.
- **Server Initializer**: Helper functions to set up and manage an OPA server instance.

## Usage

### Plug Integration

To use the OPA Plug in your Phoenix application, add it to your endpoint:

```elixir
plug OPA.Plug.Authz, package: "example_policy", rule: "allow"
```

### Simple Client

You can use the OPA client to make requests to your OPA server:

```elixir
response = OPA.Client.query("example_policy", "allow", input)
```

### Server Initializer

To start an OPA server instance, use the initializer helper:

```elixir
# Start an OPA server instance - does not error on already bound port since it
# assumes the server is already running
{:ok, _pid} = OPA.Server.HttpListener.start_link()
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `opa` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:opa, "~> 0.0.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/opa>.
