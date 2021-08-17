# Start from the latest golang base image
FROM golang:latest AS build

WORKDIR /app

ARG GITHUB_USER=$GITHUB_USER
ARG GITHUB_TOKEN=$GITHUB_TOKEN

COPY go.mod .
COPY go.sum .

RUN echo "machine github.com login $GITHUB_USER password $GITHUB_TOKEN" > ~/.netrc

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o HelloGo .

FROM alpine:latest

WORKDIR /app

COPY . .
COPY --from=build /app/HelloGo . 

EXPOSE 8080

ENTRYPOINT ["./HelloGo"]

