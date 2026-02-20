mix phx.new seq_test_api --app seq_test  --no-html --no-assets --database postgres
mix phx.gen.schema User users name:string age:integer
mix ecto.create
mix ecto.migrate
