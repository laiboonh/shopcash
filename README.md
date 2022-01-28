# Shopcash

## Description
Provide REST API endpoint for user to find out the nearest carpark from given location (latitude, longitude) with available lots.

## How to start

### Via docker-compose

#### Prerequisite
- Have docker desktop up and running
- `docker-compose up -d` Observe the logs. This might take quite a while to boot up. It setups up database as well as populate it.
- `curl "http://localhost:4000/carparks/nearest?latitude=1.37326&longitude=103.897&page=1&per_page=3"`

### Via local environment

#### Prerequisite
- Have elixir/erlang installed with mix working.
- Have a local postgresql installed and running. See `config/dev.exs` for local db configurations.

#### Start
1. `mix deps.get`
2. `mix ecto.setup`
3. `mix load_carpark`
4. `mix load_availability`
5. `mix phx.server`
6. `curl "http://localhost:4000/carparks/nearest?latitude=1.37326&longitude=103.897&page=1&per_page=3"`


## Considerations

### Load carpark information
- I coded it to fail fast because considering the use case we will want to manually fix the source data file if something is amiss and try again until all records go into the DB with no issue.
- Could have implemented DB transaction to create all carpark records or nothing at all. Currently if operation fails halfway (say conversion failed due to unresponsive api) one would need to manualy cleanup table and restart mix task.
- Calling a REST endpoint for svy21 conversion is less reliable than if we had a library doing it. Http retries would help improve reliability.
- File is streamed and httpoison configured to use default connection pool. Memory usage should be kept at bay here

### Load availability
- Assumption: Some carparks have multiple `carpark_info` e.g. number C7. I assume response in `/carparks/nearest` API returns the sum of all carpark_info regardless of `lot_type`.  
- No DB transaction was used when updating carpark_availability assuming we want a best effort approach. Updating some of the carparks is better than not updating at all. This is really down to requirement. From what i see it is meant to be run at time intervals so perhaps subsequent tries will update carparks which failed the first attempt.
- We can probably do some data sanitization to make sure total_lots > available_lots but i feel data quality should be addressed at source.
- It seems that httpoison does not have a streaming api. If carpark_availability returns a large response it may cost a server to be less responsive due to limited memory.
- `def update_availability(number, total_lots, available_lots) do`. Its quite easy to mix up `total_lots` & `available_lots` and place the wrong argument positionally. One improvement can be to invent a struct `%Availability{total_lots: 0, available_lots: 0}` Believe it will help to prevent bugs.

### Nearest API
- Every call to `/carparks/nearest?latitude=1.37326&longitude=103.897&page=1&per_page=3` results in a hit of function `nearest_available_carparks` of 4*O(n) complexity. As improvement, i would create a supervised Agent process whose responsiblity is to keep result of first hit of `euclidean_distance` and sort. A cache that is a map of `{latitude, longitude} -> list(carpark.number)`. Subsequent requests will consult this cache, figure out the carpark numbers that satisfy `page` and `per_page`, use that information to query database for carpark details and return response. 
- As number of carparks increase, this cache will likely grow linearly in size. A proper caching solution like Redis can be looked into when that happens.
- As this cache basically is a single process with one mailbox it might impact performance when many request for `nearest_available_carparks` all happen at the same time because the process can only reply to each request sequentially.
- When `load_availability` is called we would need to clear this cache. For end user they might see some weird behaviour e.g.carpark A appears in page 10 after clicking next page carpark A appears again due to new loaded availability information. If we have a web app we can probably inform user of newly laoded availability via websocket.


## Credits
- https://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula 

## Conclusion
"Make it work, make it right, make it fast". I stopped at "make it work". I would definitely refactor some module naming and directory structure. its a bit messy to me currently.