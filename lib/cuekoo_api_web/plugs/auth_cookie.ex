defmodule CuekooApiWeb.Plugs.AuthCookie do
  @moduledoc """
  Extracts an auth token from the configured cookie and places it where
  Guardian.Plug can find it (for example, into the `authorization` header
  or `conn.private`) so that downstream Guardian plugs can authenticate.

  It is intentionally small and has no side effects when no cookie is present.
  """

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    config = Application.get_env(:cuekoo_api, :auth_cookie, [])
    cookie_name = Keyword.get(config, :name, "auth_token")

    case conn.cookies[cookie_name] do
      nil ->
        conn

      token when is_binary(token) ->
        # Put token into Guardian's current token storage so the Guardian pipeline
        # can verify/load the resource as usual.
        Guardian.Plug.put_current_token(conn, token)
    end
  end
end
