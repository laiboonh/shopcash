# Shopcash

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


## How to

### Load carpark information 
Note: we stream the csv data file and configure http client to use a connection pool. So we shouldn't be running into memory issues.

`mix load_carpark`


## Considerations
- No DB transaction was used when adding carpark_information. I coded it to fail fast because considering the use case we will want to manually fix the source data file if something is amiss and try again until all records go into the DB with no issue.
- No DB transaction was used when updating carpark_availability assuming we want a best effort approach. Updating some of the carparks is better than not updating at all. This is down to requirement. From what i see it is meant to be run at time intervals so perhaps subsequent tries will update carparks which failed the first attempt.
- We can probably do some data sanitization to make sure total_lots > available_lots but i feel data quality should be addressed at source
- It seems that httpoison does not have a streaming api. If carpark_availability returns a large response it may cost a server to be less responsive due to limited memory.
- `def update_availability(number, total_lots, available_lots) do`. Its quite easy to mix up `total_lots` & `available_lots` and place the wrong argument positionally. One improvement can be to invent a struct `%Availability{total_lots: 0, available_lots: 0}` Believe it will help to prevent bugs.