output "rancher_url" {
  value = "https://${join(".", ["rancher", aws_instance.rancher_servers[0].public_ip, "sslip.io"])}"
}