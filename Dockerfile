# Build stage: compile paqet
FROM golang:1.25-alpine AS builder

# Install build deps (libpcap headers, etc.)
RUN apk add --no-cache build-base libpcap-dev

WORKDIR /build
# Copy source
COPY . .

# Build the binary
RUN go build -o paqet ./cmd/...

# Final stage: minimal image
FROM alpine:latest

# Required libs (if any)
RUN apk add --no-cache libpcap net-tools

# Copy compiled binary
COPY --from=builder /build/paqet /usr/local/bin/paqet

ENTRYPOINT ["paqet"]
