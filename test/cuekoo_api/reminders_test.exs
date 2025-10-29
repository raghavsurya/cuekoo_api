defmodule CuekooApi.RemindersTest do
  use CuekooApi.DataCase

  alias CuekooApi.Reminders

  describe "reminder" do
    alias CuekooApi.Reminders.Reminder

    import CuekooApi.RemindersFixtures

    @invalid_attrs %{name: nil, location: nil, event_scheduled_at: nil, remind_frequency: nil, is_active: nil}

    test "list_reminder/0 returns all reminder" do
      reminder = reminder_fixture()
      assert Reminders.list_reminders() == [reminder]
    end

    test "get_reminder!/1 returns the reminder with given id" do
      reminder = reminder_fixture()
      assert Reminders.get_reminder!(reminder.id) == reminder
    end

    test "create_reminder/1 with valid data creates a reminder" do
      valid_attrs = %{name: "some name", location: %{}, event_scheduled_at: ~U[2025-10-14 21:34:00Z], remind_frequency: "some remind_frequency", is_active: true}

      assert {:ok, %Reminder{} = reminder} = Reminders.create_reminder(valid_attrs)
      assert reminder.name == "some name"
      assert reminder.location == %{}
      assert reminder.event_scheduled_at == ~U[2025-10-14 21:34:00Z]
      assert reminder.remind_frequency == "some remind_frequency"
      assert reminder.is_active == true
    end

    test "create_reminder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reminders.create_reminder(@invalid_attrs)
    end

    test "update_reminder/2 with valid data updates the reminder" do
      reminder = reminder_fixture()
      update_attrs = %{name: "some updated name", location: %{}, event_scheduled_at: ~U[2025-10-15 21:34:00Z], remind_frequency: "some updated remind_frequency", is_active: false}

      assert {:ok, %Reminder{} = reminder} = Reminders.update_reminder(reminder, update_attrs)
      assert reminder.name == "some updated name"
      assert reminder.location == %{}
      assert reminder.event_scheduled_at == ~U[2025-10-15 21:34:00Z]
      assert reminder.remind_frequency == "some updated remind_frequency"
      assert reminder.is_active == false
    end

    test "update_reminder/2 with invalid data returns error changeset" do
      reminder = reminder_fixture()
      assert {:error, %Ecto.Changeset{}} = Reminders.update_reminder(reminder, @invalid_attrs)
      assert reminder == Reminders.get_reminder!(reminder.id)
    end

    test "delete_reminder/1 deletes the reminder" do
      reminder = reminder_fixture()
      assert {:ok, %Reminder{}} = Reminders.delete_reminder(reminder)
      assert_raise Ecto.NoResultsError, fn -> Reminders.get_reminder!(reminder.id) end
    end

    test "change_reminder/1 returns a reminder changeset" do
      reminder = reminder_fixture()
      assert %Ecto.Changeset{} = Reminders.change_reminder(reminder)
    end
  end
end
