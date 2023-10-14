module "server" {
  source      = "./modules/mc_server"
  server_name = "world-1"
  server_port = 25569
}

output "server_port" {
    value = module.server.server_port
}