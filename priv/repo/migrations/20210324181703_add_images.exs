defmodule Canvas.Repo.Migrations.AddImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :width, :integer
      add :height, :integer

      timestamps()
    end
  end
end
