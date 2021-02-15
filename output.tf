output "zookeeper_backup_metrics" {
  value = "${join(":5000/metrics, ", var.server_ip_address_list)}:5000/metrics"
}

output "zookeeper_ui" {
  value = "${join(":9000/metrics, ", var.server_ip_address_list)}:9000/metrics"
}