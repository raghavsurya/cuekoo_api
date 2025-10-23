defmodule CuekooApi.Auth.ErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler
  import Plug.Conn

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type), reason: to_string(reason)})
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end

end
