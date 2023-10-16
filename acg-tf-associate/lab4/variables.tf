variable "web_ingress_rules" {
  # type definitons not really required, but it might be helpful for readability
  type = list(object({
    port  = number
    proto = string
    cidr  = list(string)
  }))
  default = [
    {
      port  = 80
      proto = "tcp"
      cidr  = ["0.0.0.0/0"]
    },
    {
      port  = 22
      proto = "tcp"
      cidr  = ["0.0.0.0/0"]
    },
    {
      port  = 3689
      proto = "tcp"
      cidr  = ["6.7.8.9/32"]
    }
  ]
}
