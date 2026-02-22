defmodule CuekooApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  #@primary_key {:id, :integer, autogenerate: true}
  @foreign_key_type :binary_id

  @derive {Jason.Encoder, only: [:name, :address, :password, :email, :id, :inserted_at, :updated_at]}

  schema "users" do
    field :name, :string
    field :address, :string
    field :password, :string, redact: true, virtual: true
    field :email, :string
    field :hashed_password, :string, redact: true
    field :confirmed_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :address, :password, :confirmed_at])
    |> validate_required([:name, :email, :address, :password])
    |> validate_email_format()
    |> validate_password()
    |> unique_constraint(:email)
  end

  def validate_email_format(changeset) do
    changeset
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end

  def validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 8, max: 16)
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/[0-9]/, message: "at least one number")
    |> validate_format(:password, ~r/[^A-Za-z0-9]/, message: "at least one special character")
    |> maybe_hash_password()
  end

  def maybe_hash_password(changeset) do
    password = get_change(changeset, :password)
    if changeset.valid? do
      changeset
      |> put_change(:hashed_password, Argon2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
