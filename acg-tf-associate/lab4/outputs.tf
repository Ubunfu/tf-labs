output "Server-URL" {
  description = "Publicly accessible address of my web server"
  value       = join("", ["http://", aws_instance.web-server.public_ip])
}

output "Time-Date" {
  description = "The date/time stamp that the server was created"
  value       = timestamp()
}
