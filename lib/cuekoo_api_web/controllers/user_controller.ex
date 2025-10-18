defmodule CuekooApiWeb.UserController do
  use CuekooApiWeb, :controller
  alias CuekooApi.Users.User

  @doc """
  Create a new user
  """
  @spec create(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def create(conn, params) do
    %{"name" => _, "address" => _, "password" => _} = params

    case CuekooApi.Users.create_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{message: "User created successfully", user_id: user.id})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset})
    end
  end

  @doc """
  Show user details by ID
  """
  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    case CuekooApi.Users.get_user!(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        conn
        |> put_status(:ok)
        |> json(%{user: user})
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, user} <- CuekooApi.Users.get_user!(id),
         {:ok, %User{} = user} <- CuekooApi.Users.update_user(user, params) do
      conn
      |> put_status(:ok)
      |> json(%{message: "User updated successfully", user: user})
    else
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset})
    end
  end
end
