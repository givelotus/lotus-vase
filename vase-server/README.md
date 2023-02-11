# Vase Server

### Setup

- Install [go](https://go.dev/doc/install)
- Install project dependencies

```
go get
```

- Install air

```
go install github.com/cosmtrek/air@latest
```

**Ensure go and air are available in your path**

- Start the database and setup tables

```
docker-compose up -d
go run migrate/migrate.go
```


- Start server

```
air
```

- Send a test post

```
./test-post.sh
```