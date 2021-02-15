# Calculate hash of the Docker image source contents
data "external" "hash" {
  count = var.enable_image_push ? 1 : 0
  program = [
    coalesce(var.hash_script, "./${path.module}/hash.sh"), var.source_path]
}

# Build and push the Docker image whenever the hash changes

resource "null_resource" "push" {
  count = var.enable_image_push ? 1 : 0
  triggers = {
    hash = lookup(data.external.hash[0].result, "hash")
  }
  provisioner "local-exec" {
    command     = "${coalesce(var.push_script, "${path.module}/push.sh")} '${var.source_path}' '${var.repository_url}' ${var.tag}"
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "delay-hack" {
  count = var.enable_image_push ? 1 : 0
  depends_on = [null_resource.push[0]]
}