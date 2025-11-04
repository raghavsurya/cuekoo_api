defmodule CuekooApiWeb.SessionController do
  use CuekooApiWeb, :controller
  alias CuekooApi.{Auth.AuthManager, Auth.Guardian, Users.User, Users}

  @spec new(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    IO.inspect(changeset, label: "Session Changeset")
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      conn
      |> put_status(:ok)
      |> json(%{message: "User already logged in", user: maybe_user})
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{message: "No active session"})
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case AuthManager.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        # Read cookie options from config so dev vs prod behavior is centralized.
        cfg = Application.get_env(:cuekoo_api, :auth_cookie, [])
        cookie_name = Keyword.get(cfg, :name, "auth_token")
        http_only = Keyword.get(cfg, :http_only, true)
        secure = Keyword.get(cfg, :secure, true)
        max_age = Keyword.get(cfg, :max_age, 7 * 24 * 60 * 60)

        same_site =
          case Keyword.get(cfg, :same_site, "Strict") do
            s when is_atom(s) -> s |> Atom.to_string() |> String.capitalize()
            s when is_binary(s) -> s |> String.downcase() |> String.capitalize()
          end

        conn
        |> put_resp_cookie(cookie_name, token,
          http_only: http_only,
          secure: secure,
          max_age: max_age,
          same_site: same_site
        )
        |> put_status(:ok)
        |> json(%{message: "Login successful", user: user})

      {:error, :invalid_password} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid password"})

      {:error, :user_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
    end
  end

  def logout(conn, _params) do
    cfg = Application.get_env(:cuekoo_api, :auth_cookie, [])
    cookie_name = Keyword.get(cfg, :name, "auth_token")

    conn
    |> Guardian.Plug.sign_out()
    |> delete_resp_cookie(cookie_name)
    |> put_status(:ok)
    |> json(%{message: "Logged out successfully"})
  end
end
