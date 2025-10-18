defmodule CuekooApi.Repo.Migrations.AddTableReminders do
  use Ecto.Migration

  def change do
    create table(:reminders) do
      add :name, :string
      add :event_scheduled_at, :utc_datetime
      add :remind_frequency, :string
      add :location, :jsonb, default: "{}", null: false
      add :notes, :string
      add :is_active, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

  create index(:reminders, [:user_id])
  end
end
