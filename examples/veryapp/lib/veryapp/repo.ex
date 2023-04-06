defmodule Veryapp.Repo do
  use Ecto.Repo,
    otp_app: :veryapp,
    adapter: Ecto.Adapters.Postgres
end
