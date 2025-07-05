# Build stage
FROM golang:1.22.5 AS builder

WORKDIR /app

# Copy go mod files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the entire source code (including static files, HTML templates, etc.)
COPY . .

# Build the Go binary
RUN go build -o main .

# Final image: use Distroless for minimal footprint
FROM gcr.io/distroless/base

# Copy the built binary
COPY --from=builder /app/main /

# If your app needs static assets or templates, copy them here
COPY --from=builder /app/static /static

EXPOSE 8080

CMD ["/main"]
