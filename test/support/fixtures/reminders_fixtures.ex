defmodule CuekooApi.RemindersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CuekooApi.Reminders` context.
  """

  @doc """
  Generate a reminder.
  """
  def reminder_fixture(attrs \\ %{}) do
    {:ok, reminder} =
      attrs
      |> Enum.into(%{
        event_scheduled_at: ~U[2025-10-14 21:34:00Z],
        is_active: true,
        location: %{},
        name: "some name",
        remind_frequency: "some remind_frequency"
      })
      |> CuekooApi.Reminders.create_reminder()

    reminder
  end
end
