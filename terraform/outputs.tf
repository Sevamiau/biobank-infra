output "elastic_ip" {
  description = "Static public IP of the server"
  value       = aws_eip.repo_mds.public_ip
}

output "ssh_command" {
  description = "Ready-to-use SSH command"
  value       = "ssh -i ~/.ssh/${var.key_pair_name}.pem ubuntu@${aws_eip.repo_mds.public_ip}"
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.repo_mds.id
}
