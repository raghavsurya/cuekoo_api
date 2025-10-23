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

        conn
        |> put_status(:ok)
        |> json(%{message: "Login successful", token: token, user: user})

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
    conn
    |> Guardian.Plug.sign_out()
    |> put_status(:ok)
    |> json(%{message: "Logged out successfully"})
  end
end
