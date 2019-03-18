output "proxy_public_ip" {
  value = "${module.proxy.proxy_public_ip}"
}

output "jumpbox_public_ip" {
  value = "${module.management.jumpbox_public_ip}"
}

output "nessus_public_ip" {
  value = "${module.scanners.nessus_public_ip}"
}

output "mailserver_public_ip" {
  value = "${module.ops.mailserver_public_ip}"
}

output "grr_rds_endpoint" {
  description = "The connection endpoint"
  value       = "${module.rds.grr_rds_endpoint}"
}

output "misp_rds_endpoint" {
  description = "The connection endpoint"
  value       = "${module.rds.misp_rds_endpoint}"
}

output "burpenterprise_rds_endpoint" {
  description = "The connection endpoint"
  value       = "${module.rds.burpenterprise_rds_endpoint}"
}

output "sonarqube_rds_endpoint" {
  description = "The connection endpoint"
  value       = "${module.rds.sonarqube_rds_endpoint}"
}

output "dtrack_rds_endpoint" {
  description = "The connection endpoint"
  value       = "${module.rds.dtrack_rds_endpoint}"
}

output "vulnreport_rds_endpoint" {
  description = "The connection endpoint"
  value       = "${module.rds.vulnreport_rds_endpoint}"
}
