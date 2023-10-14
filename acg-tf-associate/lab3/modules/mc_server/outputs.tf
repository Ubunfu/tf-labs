output "server_port" {
  value = docker_container.server.ports[0].external
}