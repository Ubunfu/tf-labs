terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# Pulls the image
resource "docker_image" "server_image" {
  name = var.server_image
}

# Create a container
resource "docker_container" "server" {
  image = docker_image.server_image.image_id
  name  = var.server_name
  env = [
    "EULA=TRUE"
  ]
  ports {
    external = var.server_port
    internal = 25565
    protocol = "tcp"
  }
}
