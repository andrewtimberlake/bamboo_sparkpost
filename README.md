# Bamboo.SparkPostAdapter
[![Build Status](https://travis-ci.org/andrewtimberlake/bamboo_sparkpost.svg?branch=master)](https://travis-ci.org/andrewtimberlake/bamboo_sparkpost)

An Adapter for the [Bamboo](https://github.com/thoughtbot/bamboo) email app.

## Installation

The package can be installed as:

  1. Add bamboo_sparkpost to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:bamboo_sparkpost, "~> 1.1"}]
end
```

  2. Ensure bamboo is started before your application:

```elixir
def application do
  [applications: [:bamboo]]
end
```

  3. Add your SparkPost API key to your config

```elixir
# In your config/config.exs file
config :my_app, MyApp.Mailer,
  adapter: Bamboo.SparkPostAdapter,
  api_key: "my-api-key"
```

If you are using SparkPost EU, make sure to also add this `:bamboo` configuration:

```elixir
# In your config/config.exs file
config :bamboo,
  sparkpost_base_uri: "https://api.eu.sparkpost.com"
```

  4. Follow Bamboo [Getting Started Guide](https://github.com/thoughtbot/bamboo#getting-started)

  5. Optionally add `hackney_options` or `request_headers`

```elixir
# In your config/config.exs file
config :my_app, MyApp.Mailer,
  adapter: Bamboo.SparkPostAdapter,
  api_key: "my-api-key",
  hackney_options: [
    connect_timeout: 8_000,
    recv_timeout: 5_000
  ],
  request_headers: [{"X-MSYS-SUBACCOUNT", "123"}]
```


## Advanced Usage

The SparkPost adapter provides a helper module for setting tags and other meta data

### Examples

```elixir
include Bamboo.SparkPostHelper

email
|> tag("my-tag")
|> mark_transactional
|> disable_open_tracking
|> disable_click_tracking
|> meta_data(foo: "bar")
```
