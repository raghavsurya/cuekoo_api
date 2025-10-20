defmodule CuekooApi.Reminders.Reminder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reminders" do
    field :name, :string
    field :location, :map
    field :notes, :string
    field :event_scheduled_at, :utc_datetime
    field :remind_frequency, :string
    field :is_active, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reminder, attrs) do
    reminder
    |> cast(attrs, [:name, :event_scheduled_at, :remind_frequency, :location, :notes, :is_active])
    |> validate_required([:name, :event_scheduled_at, :remind_frequency, :is_active])
  end
end
