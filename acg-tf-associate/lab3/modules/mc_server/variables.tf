variable "server_image" {
  type        = string
  description = "The container image for the minecraft server"
  default     = "itzg/minecraft-server:latest"
}

variable "server_name" {
  type        = string
  description = "The name of the server container"
  default     = "mc-server"
}

variable "server_port" {
  type        = number
  description = "The port the server should be exposed on"
  default     = 25565
}
