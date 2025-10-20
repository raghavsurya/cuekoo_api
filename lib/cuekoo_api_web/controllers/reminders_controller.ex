defmodule CuekooApiWeb.RemindersController do
  use CuekooApiWeb, :controller


  def index(conn, _params) do
    reminders = CuekooApi.Reminders.list_reminders()
    conn
    |> put_status(:ok)
    |> json(%{reminders: reminders})
  end

  def new(conn, params) do
    case CuekooApi.Reminders.create_reminder(params) do
      {:ok, reminder} ->
        conn
        |> put_status(:created)
        |> json(%{message: "Reminder created successfully", reminder_id: reminder.id})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset})
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, reminder} <- CuekooApi.Reminders.get_reminder!(id),
         {:ok, %CuekooApi.Reminders.Reminder{} = reminder} <- CuekooApi.Reminders.update_reminder(reminder, params) do
      conn
      |> put_status(:ok)
      |> json(%{message: "Reminder updated successfully", reminder: reminder})
    else
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Reminder not found"})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset})
    end
  end


end
