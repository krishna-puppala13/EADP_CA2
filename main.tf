provider "kubernetes" {
  config_path = "~/.kube/config"
}

# MongoDB PVC
resource "kubernetes_manifest" "mongo_pvc" {
  manifest = yamldecode(file("${path.module}/k8s/mongo-pvc.yaml"))
}

# MongoDB Deployment
resource "kubernetes_manifest" "mongodb" {
  manifest = yamldecode(file("${path.module}/k8s/mongodb.yaml"))
}

# MongoDB Service
resource "kubernetes_manifest" "mongodb_service" {
  manifest = yamldecode(file("${path.module}/k8s/mongodb-service.yaml"))
}

# Backend Deployment
resource "kubernetes_manifest" "backend" {
  manifest = yamldecode(file("${path.module}/k8s/backend.yaml"))
  depends_on = [kubernetes_manifest.mongodb]
}

# Backend Service
resource "kubernetes_manifest" "backend_service" {
  manifest = yamldecode(file("${path.module}/k8s/backend-service.yaml"))
}

# Frontend Deployment
resource "kubernetes_manifest" "frontend" {
  manifest = yamldecode(file("${path.module}/k8s/frontend.yaml"))
  depends_on = [kubernetes_manifest.backend]
}

# Frontend Service
resource "kubernetes_manifest" "frontend_service" {
  manifest = yamldecode(file("${path.module}/k8s/frontend-service.yaml"))
}

resource "kubernetes_manifest" "backend_hpa" {
  manifest = yamldecode(file("${path.module}/k8s/backend-hpa.yaml"))
}

resource "kubernetes_manifest" "frontend_hpa" {
  manifest = yamldecode(file("${path.module}/k8s/frontend-hpa.yaml"))
}