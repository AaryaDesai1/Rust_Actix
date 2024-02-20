# Rust_Actix
Containerize a Rust Actix Web Service

### Objective 
The objective of this project is to containerize a Rust Actix Web Service using Docker. This mini-project will be a good first step in trying to understand how to containerize a Rust application.
**Note:** Rust automatically containerizes the application when it is built. However, this project will be using Docker to containerize the application for learning purposes. 

## Setting up the Rust Actix Web Service 
1. Create a new rust binary-based project using the following command:
```bash
cargo new rust_actix
```
Change directory into the newly created project:
```bash
cd rust_actix
```
2. Add the following dependencies to the `Cargo.toml` file:
```toml
[dependencies]
actix-web = "4"
```
3. Replace the contents of the `src/main.rs` file with the following code:
```rust
use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello world!")
}

#[post("/echo")]
async fn echo(req_body: String) -> impl Responder {
    HttpResponse::Ok().body(req_body)
}

async fn manual_hello() -> impl Responder {
    HttpResponse::Ok().body("Hey there!")
}
```
The above code sets up a simple actix web service that listens for a `GET` request at the root path and a `POST` request at the `/echo` path. When you set it up, you'll probably see a warning that the `manual_hello` function is not used. You can ignore this warning for now.
The only functionality of the `manual_hello` function is to return a string "Hey there!" when a `GET` request is made to the `/hey` path. This can be elaborated upon later. 

**Note:** I got the above code from the actix website that helps you set up a simple rust actix web service. You can find the code [here](https://actix.rs/docs/getting-started). 

4. Add the following main function in the `src/main.rs` file:
```rust
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(hello)
            .service(echo)
            .route("/hey", web::get().to(manual_hello))
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
```
The above code sets up the main function that starts the actix web service. It listens for requests on `127.0.0.1:8080`. So this will be the port that we will expose when we containerize the application. Also, you should see that all the functions that we defined earlier are being used here, and there are no more warnings.

5. Build the application using the following command:
```bash
cargo build
```
6. Run the application using the following command:
```bash
cargo run
```
7. Check that the application is running by visiting `http://127.0.0.1:8080/` in your web browser. You should see the message "Hello world!" displayed. 
<img width="1683" alt="image" src="https://github.com/AaryaDesai1/Rust_Actix/assets/143753050/ff8f06a4-de6a-4669-96f9-2f94ecc0bfda">


## Containerizing the Rust Actix Web Service
1. Create a new file called `Dockerfile` in the root of the project directory. Add the following code to the `Dockerfile`:
```Dockerfile