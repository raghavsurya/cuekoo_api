defmodule CuekooApiWeb.HomeController do
  use CuekooApiWeb, :controller

  def index(conn, _params) do

    #
    #json(conn, CuekooApiWeb.ErrorJSON.render("401.json", %{}))
    #json(conn, %{message: "Welcome to the new Cuekoo API"})

    conn |> put_resp_content_type("application/json") |> send_resp(200, ~s({"message": "Welcome to the new Cuekoo API"}))
    #send_resp(conn, 200, "Welcome to the new Cuekoo API")
  end


end
