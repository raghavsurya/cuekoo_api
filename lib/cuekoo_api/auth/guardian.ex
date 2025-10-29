defmodule CuekooApi.Auth.Guardian do
  use Guardian, otp_app: :cuekoo_api
  alias CuekooApi.Users.User

  def subject_for_token(%User{} = user, _claims) do

    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = CuekooApi.Users.get_user!(id)
    {:ok, user}

  rescue
    Ecto.NoResultsError -> {:error, :user_not_found}
  end
end
