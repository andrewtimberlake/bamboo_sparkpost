# Bamboo.SparkPostAdapter

An Adapter for the [Bamboo](https://github.com/thoughtbot/bamboo) email app.

## Installation

The package can be installed as:

  1. Add bamboo_sparkpost to your list of dependencies in `mix.exs`:

        def deps do
          [{:bamboo_sparkpost, "~> 0.5.0"}]
        end

  2. Ensure bamboo is started before your application:

        def application do
          [applications: [:bamboo]]
        end

  3. Add your SparkPost API key to your config

        # In your config/config.exs file
        config :my_app, MyApp.Mailer,
          adapter: Bamboo.SparkPostAdapter
          api_key: "my-api-key"

  4. Follow Bamboo [Getting Started Guide](https://github.com/thoughtbot/bamboo#getting-started)

## Advanced Usage

The SparkPost adapter provides a helper module for setting tags and other meta data

### Examples

    include Bamboo.SparkPostHelper

    email
    |> tag("my-tag")
    |> mark_transactional
    |> disable_open_tracking
    |> disable_click_tracking
    |> meta_data(foo: "bar")