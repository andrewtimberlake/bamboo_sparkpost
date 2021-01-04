defmodule Bamboo.SparkPostAdapter do
  @moduledoc """
  Sends email using SparkPost's JSON API.

  Use this adapter to send emails through SparkPost's API. Requires that an API
  key is set in the config. See `Bamboo.SparkPostHelper` for extra functions that
  can be used by `Bamboo.SparkPostAdapter` (tagging, merge vars, etc.)

  ## Example config

      # In config/config.exs, or config/prod.exs, etc.
      config :my_app, MyApp.Mailer,
        adapter: Bamboo.SparkPostAdapter,
        api_key: "my_api_key"

      # Define a Mailer. Maybe in lib/my_app/mailer.ex
      defmodule MyApp.Mailer do
        use Bamboo.Mailer, otp_app: :my_app
      end
  """

  @default_base_uri "https://api.sparkpost.com"
  @send_message_path "/api/v1/transmissions"
  @behaviour Bamboo.Adapter
  @service_name "SparkPost"

  import Bamboo.ApiError

  def deliver(email, config) do
    api_key = get_key(config)
    hackney_options = Map.get(config, :hackney_options, [])
    request_headers = Map.get(config, :request_headers, [])
    params = email |> convert_to_sparkpost_params |> json_library().encode!()

    case request!(@send_message_path, params, api_key, hackney_options, request_headers) do
      {:ok, status, _headers, response} when status > 299 ->
        filtered_params = params |> json_library().decode!() |> Map.put("key", "[FILTERED]")
        raise_api_error(@service_name, response, filtered_params)

      {:error, reason} ->
        raise_api_error(inspect(reason))

      response ->
        response
    end
  end

  @doc false
  def handle_config(config) do
    if config[:api_key] in [nil, ""] do
      raise_api_key_error(config)
    else
      config
    end
  end

  @doc false
  def supports_attachments?, do: true

  defp get_key(config) do
    case Map.get(config, :api_key) do
      nil -> raise_api_key_error(config)
      key -> key
    end
  end

  defp raise_api_key_error(config) do
    raise ArgumentError, """
    There was no API key set for the SparkPost adapter.

    * Here are the config options that were passed in:

    #{inspect(config)}
    """
  end

  defp convert_to_sparkpost_params(email) do
    %{
      content: %{
        from: %{
          name: email.from |> elem(0),
          email: email.from |> elem(1)
        },
        subject: email.subject,
        text: email.text_body,
        html: email.html_body,
        reply_to: extract_reply_to(email),
        headers: drop_reply_to(email_headers(email)),
        attachments: attachments(email)
      },
      recipients: recipients(email)
    }
    |> add_message_params(email)
    |> add_tags(email)
  end

  defp email_headers(email) do
    if email.cc == [] do
      email.headers
    else
      Map.put_new(
        email.headers,
        "CC",
        Enum.map(email.cc, fn {_, addr} -> addr end) |> Enum.join(",")
      )
    end
  end

  defp extract_reply_to(email) do
    email.headers["Reply-To"]
  end

  defp drop_reply_to(headers) do
    Map.delete(headers, "Reply-To")
  end

  defp add_message_params(sparkpost_message, %{private: %{message_params: message_params}}) do
    Enum.reduce(message_params, sparkpost_message, fn {key, value}, sparkpost_message ->
      Map.put(sparkpost_message, key, value)
    end)
  end

  defp add_message_params(sparkpost_message, _), do: sparkpost_message

  defp add_tags(sparkpost_message, %{private: %{tags: tags}}) do
    new_recipients =
      Enum.reduce(sparkpost_message.recipients, [], fn rcpt, acc ->
        rcpt = Map.put_new(rcpt, :tags, tags)
        [rcpt | acc]
      end)

    %{sparkpost_message | recipients: Enum.reverse(new_recipients)}
  end

  defp add_tags(sparkpost_message, _), do: sparkpost_message

  defp recipients(email) do
    []
    |> add_recipients(email.to)
    |> add_b_cc(email.cc, email.to)
    |> add_b_cc(email.bcc, email.to)
  end

  defp add_recipients(recipients, new_recipients) do
    Enum.reduce(new_recipients, recipients, fn {name, email}, recipients ->
      recipients ++ [%{"address" => %{name: name, email: email}}]
    end)
  end

  defp add_b_cc(recipients, new_recipients, to) do
    Enum.reduce(new_recipients, recipients, fn {name, email}, recipients ->
      recipients ++
        [
          %{
            "address" => %{
              name: name,
              email: email,
              header_to: Enum.map(to, fn {_, addr} -> addr end) |> Enum.join(",")
            }
          }
        ]
    end)
  end

  defp headers(api_key) do
    [{"content-type", "application/json"}, {"authorization", api_key}]
  end

  defp attachments(%{attachments: attachments}) do
    attachments
    |> Enum.reverse()
    |> Enum.map(fn att ->
      %{
        name: att.filename,
        type: att.content_type,
        data: Base.encode64(att.data)
      }
    end)
  end

  defp request!(path, params, api_key, hackney_options, request_headers) do
    uri = base_uri() <> path

    :hackney.post(
      uri,
      headers(api_key) ++ request_headers,
      params,
      [:with_body] ++ hackney_options
    )
  end

  defp base_uri do
    uri = Application.get_env(:bamboo, :sparkpost_base_uri) || @default_base_uri
    String.replace_trailing(uri, "/", "")
  end

  # Configurable JSON library is inherited from Bamboo if the version is high enough
  if :erlang.function_exported(Bamboo, :json_library, 0) do
    def json_library, do: Bamboo.json_library()
  else
    def json_library, do: Jason
  end
end
