defmodule CuekooApi.Auth.Pipleine do
  use Guardian.Plug.Pipeline,
    otp_app: :cuekoo_api,
    module: CuekooApi.Guardian,
    error_handler: CuekooApi.Auth.ErrorHandler

    # this validates a token found in the session
    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
    # if there is an authorization token in the header, validate and restrict it to an access token
    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
    # load the user if either of the verifications worked
    plug Guardian.Plug.LoadResource, allow_blank: true
end
