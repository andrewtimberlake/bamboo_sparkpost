defmodule Bamboo.SparkPostHelper do
  @moduledoc """
  Functions for using features specific to SparkPost e.g. tagging
  """

  alias Bamboo.Email

  @doc """
  Put extra message parameters that are used by SparkPost

  Parameters set with this function are sent to SparkPost when used along with
  the Bamboo.SparkPostAdapter. You can set any additional parameters that the SparkPost API supports
  Other functions in this module provide a more convenient way of setting these parameters.

  ## Example

      email
      |> put_param([:options, :open_tracking], false)
      |> put_param(:tags, ["foo", "bar"])
      |> put_param(:meta_data, %{foo: "bar"})
  """
  def put_param(email, keys, value) do
    keys = List.wrap(keys)

    message_params =
      (email.private[:message_params] || %{})
      |> ensure_keys(keys)
      |> update_value(keys, value)

    email
    |> Email.put_private(:message_params, message_params)
  end

  @doc """
  Set a single tag or multiple tags for an email.

  ## Example

      tag(email, "welcome-email")
      tag(email, ["welcome-email", "marketing"])
  """
  def tag(email, tags) do
    existing_tags = email.private[:tags] || []
    new_tags = existing_tags ++ List.wrap(tags)
    Email.put_private(email, :tags, new_tags)
  end

  @doc ~S"""
  Add meta data to an email

  ## Example

      email
      |> meta_data(foo: bar)
      |> meta_data(%{bar: "baz")
  """
  def meta_data(email, map) when is_map(map) do
    put_param(email, :metadata, map)
  end

  def meta_data(email, map) do
    put_param(email, :metadata, Enum.into(map, %{}))
  end

  @doc ~S"""
  Mark an email as transactional

  ## Example
      email |> mark_transactional
  """
  def mark_transactional(email) do
    put_param(email, [:options, :transactional], true)
  end

  @doc ~S"""
  Enables the inline CSS option

  ## Example
      email |> inline_css
  """
  def inline_css(email) do
    put_param(email, [:options, :inline_css], true)
  end

  @doc ~S"""
  Disable open tracking (SparkPost defaults to true)

  ## Example
      email |> disable_open_tracking
  """
  def disable_open_tracking(email) do
    put_param(email, [:options, :open_tracking], false)
  end

  @doc ~S"""
  Disable click tracking

  ## Example
      email |> disable_click_tracking
  """
  def disable_click_tracking(email) do
    put_param(email, [:options, :click_tracking], false)
  end

  defp update_value(map, keys, value) when is_list(value) do
    map
    |> update_in(keys, fn
      nil -> value
      val -> val ++ value
    end)
  end

  defp update_value(map, keys, value) when is_map(value) do
    map
    |> update_in(keys, fn
      nil -> value
      val -> Map.merge(val, value)
    end)
  end

  defp update_value(map, keys, value) do
    map
    |> put_in(keys, value)
  end

  defp ensure_keys(map, [key]) do
    Map.update(map, key, nil, fn value -> value end)
  end

  defp ensure_keys(map, [key | tail]) do
    Map.update(map, key, ensure_keys(%{}, tail), fn value -> ensure_keys(value, tail) end)
  end

  defp ensure_keys(map, key), do: ensure_keys(map, [key])
end
