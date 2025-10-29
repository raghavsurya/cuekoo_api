defmodule CuekooApiWeb.Router do
  use CuekooApiWeb, :router

  pipeline :auth do
    plug CuekooApi.Auth.Pipleine
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CuekooApiWeb do

    pipe_through [:api, :auth]

    get "/", HomeController, :index

    scope "/users" do

      post "/new", UserController, :create
      get "/:id", UserController, :show
      put "/:id", UserController, :update
    end

    scope "/reminders" do
      pipe_through [:ensure_auth]
      get "/", RemindersController, :index
      post "/new", RemindersController, :new
      put "/update", RemindersController, :update
    end

    scope "/auth" do
      get "/login", SessionController, :new
      post "/login", SessionController, :login
      post "/logout", SessionController, :logout
    end
  end



  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:cuekoo_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CuekooApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
