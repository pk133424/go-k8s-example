# First stage: Build the application
FROM golang:alpine3.13 AS builder

ENV PATH="/go/bin:${PATH}"
ENV GO111MODULE=on
ENV CGO_ENABLED=1

WORKDIR /app

# Install dependencies
RUN apk add --no-cache make git bash build-base pkgconf openssl-dev

# Copy source code
COPY . .

# Build the application
RUN go build -tags dynamic -o go-k8s-example .

# Second stage: Create minimal runtime image
FROM alpine:3.13

WORKDIR /app

# Install required runtime dependencies
RUN apk add --no-cache ca-certificates bash openssl

# Copy compiled binary from builder stage
COPY --from=builder /app/go-k8s-example .

# Ensure correct permissions
RUN chmod +x ./go-k8s-example

# Use a non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Entrypoint
ENTRYPOINT [ "./go-k8s-example" ]
