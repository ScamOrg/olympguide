FROM golang:latest

WORKDIR /app
COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o main ./main.go

EXPOSE ${API_PORT}
CMD ["./main"]