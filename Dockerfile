# Start from the latest golang base image
FROM golang:1.16-alpine

RUN GOCACHE=OFF

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy everything from the current directory to the Working Directory inside the container
COPY . /app

RUN apk add git

RUN go env -w GO111MODULE=on

RUN git config --global url."https://japangermany1998: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@github.com:techmaster-vietnam/private_gomod".insteadOf "https://github.com/techmaster-vietnam/private_gomod"

RUN go env -w GOPRIVATE=github.com/techmaster-vietnam

# Build the Go app
RUN go build -o HelloGo .

# Expose port 8080 to the outside world
EXPOSE 8080

#ENTRYPOINT ["/app"]

# Command to run the executable
CMD ["./HelloGo"]