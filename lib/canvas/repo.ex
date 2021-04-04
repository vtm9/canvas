defmodule Canvas.Repo do
  use Ecto.Repo,
    otp_app: :canvas,
    adapter: Ecto.Adapters.Postgres

  def count(q), do: Canvas.Repo.aggregate(q, :count, :id)
end
