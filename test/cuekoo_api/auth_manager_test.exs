defmodule CuekooApi.AuthManagerTest do
  use CuekooApi.DataCase, async: true
  alias CuekooApi.AuthManager
  alias CuekooApi.Users

  describe "authenticate_user/2" do
    setup do
      {:ok, _} =
        Users.create_user(%{
          name: "Test User",
          email: "someemail@test.com",
          password: "SomePass@2021",
          address: "123 Test St",
          hashed_password: "hashed_password"
        })

      :ok
    end

    test "returns {:ok, user} for valid credentials" do
      assert {:ok, auth_user} =
               AuthManager.authenticate_user("someemail@test.com", "SomePass@2021")

      assert auth_user.email == "someemail@test.com"
    end

    test "returns error for invalid password" do
      assert {:error, :invalid_password} =
               AuthManager.authenticate_user("someemail@test.com", "SomePpss@2021")
    end

    test "returns user not found for invalid email" do
      assert {:error, :user_not_found} =
               AuthManager.authenticate_user("dd@test.com", "SomePass@2021")
    end
  end
end
