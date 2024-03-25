# Rust_Actix
Containerize a Rust Actix Web Service using Docker

[![Rust Microservice CI/CD](https://github.com/AaryaDesai1/Rust_Actix/actions/workflows/actions.yml/badge.svg)](https://github.com/AaryaDesai1/Rust_Actix/actions/workflows/actions.yml)

### Objective 
The objective of this project is to containerize a Rust Actix Web Service using Docker. This mini-project will be a good first step in trying to understand how to containerize a Rust application.


Added Additional Endpoints:
I added two new endpoints (/user/{id} and /user) to demonstrate a broader understanding of Actix-web and to showcase how to handle different types of HTTP requests (GET and POST). These endpoints simulate fetching user information based on user IDs and creating users with POST requests.
Improved Path Parameter Handling:
I replaced the nested web::Path extractor with a direct use of web::Path<u32> in the get_user_info handler function signature. This simplifies the code and ensures correct handling of path parameters.
Enhanced Documentation:
While not explicitly mentioned in the code changes, improving documentation is crucial for understanding and maintaining the codebase. I've provided explanations and comments in the code to help understand the purpose of each endpoint and function.
Testing in Browser:
I guided you on how to test your application in the browser by providing the URLs for accessing different endpoints. This ensures you can easily verify the functionality of your application during development.

### Why are we containerizing the Rust Actix Web Service?
We've had a few discussions about why containerization is necessary for Rust that automatically creates binaries. The main reason is that the binaries created by Rust are not portable. This means that if you create a binary on your local machine, you cannot run it on another machine with a different operating system. This is because the binary is compiled for a specific operating system and architecture. This is where containerization comes in. Containerization allows you to package your application and all its dependencies into a single image that can be run on any machine. This is why we are containerizing the Rust Actix Web Service. 

## Setting up the Rust Actix Web Service 
1. Create a new rust binary-based project using the following command:
```bash
cargo new rust_actix
```
**IMPORTANT** Move all the contents of the `rust_actix` directory to the root of the project directory. This is because the Dockerfile will be looking for the `Cargo.toml` file in the root of the project directory. If you **DO NOT** do this, you will get an error when you try to build the Docker image, specifically for the `COPY` command in the Dockerfile.
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


## Containerizing the Rust Actix Web Service using Docker

### Prerequisites
Install Docker on your local machine. You can find the installation instructions [here](https://docs.docker.com/desktop/install/mac-install/) for Mac users. This is really important because there could be compatibility issues with Docker and your operating system and/or your hardware. 

1. Create a new file called `Dockerfile` in the root of the project directory. Click [here]() to see the contents of the `Dockerfile`.
2. Open a terminal in the directory containing your Dockerfile.Run 
```
docker build -t <USERNAME>/your-image-name . 
```
**Note:** KEEP the period at the end of the command. This tells Docker to look for the Dockerfile in the current directory.
[Replace your-image-name with a suitable name for your Docker image.]
3. Run your Docker container locally using the following command:
```
docker run -p 8080:8080 <USERNAME>/your-image-name
```
4. Check that the application is running by visiting `http://127.0.0.1:8080/` in your web browser. You should see the message "Hello world!" displayed. 

### Conclusion
