module "server" {
  source      = "./modules/mc_server"
  server_name = "world-1"
  server_port = 25569
}