defmodule CuekooApiWeb.RemindersController do
  use CuekooApiWeb, :controller


  def index(conn, _params) do
    conn |> put_resp_content_type("application/json") |> send_resp(200, ~s({"message": "Create a reminder!"}))
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
end
