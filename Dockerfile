# Stage 1: Build the Rust application
FROM rust:latest as builder

WORKDIR /usr/src/app

# Copy only the dependency manifest files
COPY Cargo.toml Cargo.lock ./

# Build dependencies separately to cache them
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm src/main.rs

# Copy the rest of the source code
COPY . .

# Build the application
RUN cargo build --release

# Stage 2: Create the final lightweight image
FROM debian:buster-slim

WORKDIR /usr/src/app

# Copy the compiled binary from the builder stage
COPY --from=builder /usr/src/app/target/release/rust_actix .

EXPOSE 8080

CMD ["./rust_actix"]
