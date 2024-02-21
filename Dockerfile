# Use the official Rust image as the base image
FROM rust:latest as builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the source code into the container
COPY . .

# Build the Rust application
RUN cargo build --release

# Use a smaller base image for the final container
FROM debian:buster-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the compiled binary from the builder stage to the final image
COPY --from=builder /usr/src/app/target/release/rust_actix .

# Expose the port on which your Actix web service listens
EXPOSE 8080

# Command to run the binary when the container starts
CMD ["./rust_actix"]
