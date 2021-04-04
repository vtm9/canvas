.PHONY: test

default: format test

server:
	iex -S mix phx.server

test:
	mix test --cover

format:
	mix format

pg:
	docker-compose up -d db

setup:
	mix ecto.setup
