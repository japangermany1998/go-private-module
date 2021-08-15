# Start from the latest golang base image
FROM golang:1.16-alpine

RUN GOCACHE=OFF

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy everything from the current directory to the Working Directory inside the container
COPY . /app

RUN apk add git

RUN go env -w GO111MODULE=on

RUN go env -w GOPRIVATE=github.com/techmaster-vietnam

RUN git config --global url."https://japangermany1998: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@github.com/techmaster-vietnam/private_gomod.git".insteadOf "https://github.com/techmaster-vietnam/private_gomod.git"

# Build the Go app
RUN go build -o HelloGo .

# Expose port 8080 to the outside world
EXPOSE 8080

#ENTRYPOINT ["/app"]

# Command to run the executable
CMD ["./HelloGo"]