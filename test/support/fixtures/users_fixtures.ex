defmodule CuekooApi.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CuekooApi.Users` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        address: "some address",
        confirmed_at: ~U[2025-10-13 19:35:00Z],
        email: unique_user_email(),
        hashed_password: "some hashed_password",
        name: "some name",
        password: "some password"
      })
      |> CuekooApi.Users.create_user()

    user
  end
end
