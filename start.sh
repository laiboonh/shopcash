#!/bin/bash

mix deps.get
mix ecto.setup
mix load_carparks
mix load_availability
mix phx.server