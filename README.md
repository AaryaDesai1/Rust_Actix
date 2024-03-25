# Rust_Actix
Containerize a Rust Actix Web Service using Docker

[![Rust Microservice CI/CD](https://github.com/AaryaDesai1/Rust_Actix/actions/workflows/actions.yml/badge.svg)](https://github.com/AaryaDesai1/Rust_Actix/actions/workflows/actions.yml)

Click [here](https://youtu.be/DY3di-sF4QI) for a video tutorial on how to containerize a Rust Actix Web Service using Docker.


### Objective 
The objective of this project is to containerize a Rust Actix Web Service using Docker. Furthermore, to use a CI/CD pipeline to automate the process of building and deploying the Docker image.


### Why are we containerizing the Rust Actix Web Service?
We've had a few discussions about why containerization is necessary for Rust that automatically creates binaries. The main reason is that the binaries created by Rust are not portable. This means that if you create a binary on your local machine, you cannot run it on another machine with a different operating system. This is because the binary is compiled for a specific operating system and architecture. This is where containerization comes in. Containerization allows you to package your application and all its dependencies into a single image that can be run on any machine. This is why we are containerizing the Rust Actix Web Service. 

## Setting up the Rust Actix Web Service 

### The Rust Actix Web Service
This web service was an improvement on the simple actix web service that I created in the previous project. The main difference is that the previous web service was a simple 'Hello World' web service that returned a string when a `GET` request was made to the root path. This web service is a bit more complex. It is a Login webservice that allows users to enter their username and password. When a `POST` request is made to the `/login` path, the web service will return the username and password that the user entered.

While the username and password are hardcoded, it provided a good starting point to learn how to create a more complex actix web service.


1. Create a new rust binary-based project using the following command:
```bash
cargo new rust_actix
```
**IMPORTANT** Move all the contents of the `rust_actix` directory to the root of the project directory. This is because the Dockerfile will be looking for the `Cargo.toml` file in the root of the project directory. If you **DO NOT** do this, you will get an error when you try to build the Docker image, specifically for the `COPY` command in the Dockerfile.

2. Add the following dependencies to the `Cargo.toml` file:
```toml
[package]
name = "rust_actix"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
actix-web = "4.5"
actix-files = { version = "0.6.0-beta.16" }
serde = { version = "1.0", features = ["derive"] }
```

3. Replace the contents of the `src/main.rs` file with the following code:
```rust
use actix_web::{post, App, HttpServer, HttpResponse, web};
use actix_web::Responder;
use serde::Deserialize;

const USERNAME: &str = "admin";
const PASSWORD: &str = "password";

#[post("/login")]
async fn login(form: web::Form<LoginForm>) -> impl Responder {
    if form.username == USERNAME && form.password == PASSWORD {
        HttpResponse::Ok().body("Login successful!")
    } else {
        HttpResponse::Unauthorized().body("Invalid username or password")
    }
}

#[derive(Deserialize)]
struct LoginForm {
    username: String,
    password: String,
}

```

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
7. Check that the application is running by visiting `http://127.0.0.1:8080/` in your web browser. You should see the message Login user interface displayed.

<img width="1683" alt="image" src="https://github.com/AaryaDesai1/Rust_Actix/assets/143753050/754be820-bf14-4ae6-8796-16fb8fbb8066">


After entering the username and password, you should see the message "Login successful!" displayed.

<img width="1683" alt="image" src="https://github.com/AaryaDesai1/Rust_Actix/assets/143753050/71e6cd93-19f2-4edc-b028-ad96ca83241d">

<img width="1682" alt="image" src="https://github.com/AaryaDesai1/Rust_Actix/assets/143753050/7e6473f0-4c0b-46f3-88f1-9cb6c11c0533">


## Containerizing the Rust Actix Web Service with Docker using GitHub Actions

### The [Dockerfile](https://github.com/AaryaDesai1/Rust_Actix/blob/main/Dockerfile)
The Dockerfile is used to build the Docker image for the Rust Actix Web Service. The Docker image contains all the dependencies and configurations required to run the web service. The Dockerfile is used to build the Docker image for the Rust Actix Web Service. The Docker image contains all the dependencies and configurations required to run the web service.

### [GitHub Actions](https://github.com/AaryaDesai1/Rust_Actix/blob/main/.github/workflows/actions.yml)
This is where I specified the steps that GitHub Actions should take to build and deploy the Docker image. The GitHub Actions workflow is triggered whenever a push is made to the main branch. The workflow consists of the following steps:
1. Checkout the code from the repository
2. Set up Rust 
3. Build the Docker image
4. Log in to Docker Hub
5. Push the Docker image to Docker Hub

### Setting up Login Credentials for Docker Hub
To push the Docker image to Docker Hub, you need to set up login credentials for Docker Hub. You can do this by creating a personal access token on Docker Hub and adding it as a secret in your GitHub repository. The personal access token is used to authenticate with Docker Hub when pushing the Docker image.

### Setting up Secrets in GitHub
To add the personal access token as a secret in your GitHub repository, follow these steps:
1. Go to your GitHub repository
2. Click on the `Settings` tab
3. Click on the `Secrets` tab
4. Click on the `New repository secret` button
5. Add a new secret with the name `DOCKERHUB_TOKEN` and the value as your Docker Hub username

### Running the GitHub Actions Workflow
Once you have set up the personal access token as a secret in your GitHub repository, you can run the GitHub Actions workflow by pushing a change to the main branch. The GitHub Actions workflow will be triggered, and you will see the progress of the workflow in the Actions tab of your GitHub repository.

