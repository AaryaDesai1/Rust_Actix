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

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(login)
            .service(actix_files::Files::new("/", "src/static").index_file("login.html"))
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
