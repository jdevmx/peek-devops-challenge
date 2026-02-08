provider "kubernetes" {
  config_path    = "~/.kube/config"
}

resource "kubernetes_namespace_v1" "peek_namespace" {
  metadata {
    name = "peek"
  }
}

locals {
  k8_files = setsubtract(
    fileset("${path.module}/k8", "*.yaml")
  )
}

resource "kubernetes_manifest" "apps" {
  for_each = local.k8_files
  manifest = yamldecode(file("${path.module}/k8/${each.value}"))
  depends_on = [kubernetes_namespace_v1.peek_namespace]
}