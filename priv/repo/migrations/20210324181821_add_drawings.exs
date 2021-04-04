defmodule Canvas.Repo.Migrations.AddDrawings do
  use Ecto.Migration

  def change do
    create table(:drawings) do
      add :image_id, references(:images)
      add :type, :string
      add :props, :jsonb

      timestamps()
    end
  end
end
