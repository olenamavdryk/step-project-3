output "jenkins_master_public_ip" {
  value = aws_instance.master.public_ip
}

output "jenkins_worker_private_ip" {
  value = aws_instance.worker.private_ip
}
