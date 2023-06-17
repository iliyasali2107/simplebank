postgres:
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15-alpine

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres15 dropdb simple_bank

migrateup:
	/home/iliyas/go/bin/migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	/home/iliyas/go/bin/migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	/home/iliyas/go/bin/sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	/home/iliyas/go/bin/mockgen -package mockdb -destination db/mock/store.go simplebank/db/sqlc Store

migratedown1:
	/home/iliyas/go/bin/migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

migrateup1:
	/home/iliyas/go/bin/migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

.PHONY: postgres createdb dropdb sqlc test server mock migratedown1 migrateup1
