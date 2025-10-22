defmodule CuekooApi.AuthManager do
  alias Argon2
  alias CuekooApi.Users.User
  alias CuekooApi.Repo
  import Ecto.Query, only: [from: 2]

  def authenticate_user(email, password) do
    query = from u in User, where: u.email == ^email
    case Repo.one(query) do
      nil ->
        {:error, :user_not_found}
      user ->
        if Argon2.verify_pass(password, user.hashed_password) do
          {:ok, user}
        else
          {:error, :invalid_password}
        end
    end
  end
end
