ndefmodule Bamboo.SparkpostHelperTest do
  use ExUnit.Case
  import Bamboo.Email
  alias Bamboo.SparkpostHelper

  test "adds tags to sparkpost emails" do
    email = new_email |> SparkpostHelper.tag("welcome-email")
    assert email.private.message_params == %{tags: ["welcome-email"]}

    email = new_email |> SparkpostHelper.tag(["welcome-email", "awesome"])
    assert email.private.message_params == %{tags: ["welcome-email", "awesome"]}

    email = new_email |> SparkpostHelper.tag(["welcome-email"]) |> SparkpostHelper.tag(["awesome"]) |> SparkpostHelper.tag("another")
    assert email.private.message_params == %{tags: ["welcome-email", "awesome", "another"]}
  end

  test "it marks the email as transactional" do
    email = new_email |> SparkpostHelper.mark_transactional
    assert email.private.message_params == %{options: %{transactional: true}}
  end

  test "it adds meta data" do
    email = new_email |> SparkpostHelper.meta_data(foo: "bar")
    assert email.private.message_params == %{metadata: %{foo: "bar"}}

    email = new_email |> SparkpostHelper.meta_data(%{foo: "bar"})
    assert email.private.message_params == %{metadata: %{foo: "bar"}}
  end

  test "it merges meta data" do
    email = new_email |> SparkpostHelper.meta_data(foo: "bar") |> SparkpostHelper.meta_data(%{bar: "baz"})
    assert email.private.message_params == %{metadata: %{foo: "bar", bar: "baz"}}
  end

  test "it disables open tracking" do
    email = new_email |> SparkpostHelper.disable_open_tracking
    assert email.private.message_params == %{options: %{open_tracking: false}}
  end

  test "it disables click tracking" do
    email = new_email |> SparkpostHelper.disable_click_tracking
    assert email.private.message_params == %{options: %{click_tracking: false}}
  end

  test "put it all together" do
    email = new_email
    |> SparkpostHelper.disable_click_tracking
    |> SparkpostHelper.disable_open_tracking
    |> SparkpostHelper.mark_transactional
    |> SparkpostHelper.tag(["foo", "bar"])
    |> SparkpostHelper.meta_data(foo: "bar")

    assert email.private.message_params == %{
      options: %{open_tracking: false, transactional: true, click_tracking: false},
      metadata: %{foo: "bar"},
      tags: ["foo", "bar"]
    }
  end
end
