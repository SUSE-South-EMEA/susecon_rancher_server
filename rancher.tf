# Initialize Rancher server
resource "rancher2_bootstrap" "admin" {
  depends_on = [
    helm_release.rancher_server,
  ]

  provider = rancher2.bootstrap

  password  = var.rancher_server_admin_password
  telemetry = true
}

