defmodule CuekooApi.Repo do
  use Ecto.Repo,
    otp_app: :cuekoo_api,
    adapter: Ecto.Adapters.Postgres
end
