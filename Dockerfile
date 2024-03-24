# Multi-stage build to reduce the size of the final Docker image
FROM rust:latest as builder

WORKDIR /usr/src/app
COPY . .

RUN cargo build --release

FROM debian:buster-slim

WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/target/release/rust_actix .

EXPOSE 8080

CMD ["./rust_actix"]
