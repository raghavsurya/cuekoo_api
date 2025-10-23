defmodule CuekooApi.AuthManager do
  alias Argon2
  alias CuekooApi.Users.User
  alias CuekooApi.Repo
  import Ecto.Query, only: [from: 2]

  def authenticate_user(email, password) do
    query = from u in User, where: u.email == ^email
    case Repo.one(query) do
      nil ->
        # TODO: This function apparently takes more resources to mitigate timing attacks (CPU and Memory).
        # So add monitoring (metric) around it to ensure it does not become a bottleneck.
        Argon2.no_user_verify()
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
