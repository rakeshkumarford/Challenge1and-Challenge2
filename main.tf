# Configure the provider
provider "docker" {
  host = "tcp://localhost:2376/"
}

# Create the Docker image
resource "docker_image" "mediawiki" {
  name = "mediawiki"
  build {
    context = "."
  }
}

# Create the MySQL container
resource "docker_container" "mysql" {
  name  = "mysql"
  image = "mysql"
  env = [
    "MYSQL_ROOT_PASSWORD=secretpassword"
  ]
}

# Create the MediaWiki container
resource "docker_container" "mediawiki" {
  name  = "mediawiki"
  image = docker_image.mediawiki.latest
  links = [
    "${docker_container.mysql.name}:mysql"
  ]
  env = [
    "MW_DB_HOST=mysql",
    "MW_DB_USER=root",
    "MW_DB_PASSWORD=secretpassword",
    "MW_DB_NAME=mediawiki"
  ]
  ports {
    internal = 80
    external = 8080
  }
}
