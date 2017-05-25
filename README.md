<a href="https://www.sparkpost.com"><img src="https://www.sparkpost.com/sites/default/files/attachments/SparkPost_Logo_2-Color_Gray-Orange_RGB.svg" width="200px"/></a>

[Sign up](https://app.sparkpost.com/sign-up?src=Dev-Website&sfdcid=70160000000pqBb) for a SparkPost account and visit our [Developer Hub](https://developers.sparkpost.com) for even more content.

# Bamboo SparkPost Adapter

[![Travis CI](https://travis-ci.org/SparkPost/bamboo_sparkpost.svg?branch=master)](https://travis-ci.org/SparkPost/bamboo_sparkpost) [![Coverage Status](https://coveralls.io/repos/SparkPost/bamboo_sparkpost/badge.svg?branch=master&service=github)](https://coveralls.io/github/SparkPost/bamboo_sparkpost?branch=master) [![Slack Status](http://slack.sparkpost.com/badge.svg)](http://slack.sparkpost.com)

An Adapter for the [Bamboo](https://github.com/thoughtbot/bamboo) email app.

## Installation

The package can be installed as:

  1. Add bamboo_sparkpost to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:bamboo_sparkpost, "~> 0.5.0"}]
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
  adapter: Bamboo.SparkPostAdapter
  api_key: "my-api-key"
```

  4. Follow Bamboo [Getting Started Guide](https://github.com/thoughtbot/bamboo#getting-started)

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
