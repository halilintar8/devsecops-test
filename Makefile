# ===============================
# 🧰 DevSecOps Project Makefile
# ===============================

# ---- Variables ----
APP_NAME := devsecops-api
IMAGE_NAME := devsecops-test-api
IMAGE_TAG := latest
DOCKER_CMD := podman
PORT := 8000

# ---- Default target ----
.DEFAULT_GOAL := help

# ---- Help ----
help:
	@echo "Available commands:"
	@echo "  make build      Build Docker image for API"
	@echo "  make run        Run API container (with Infisical secrets)"
	@echo "  make stop       Stop running API container"
	@echo "  make scan       Scan Docker image with Trivy"
	@echo "  make clean      Remove unused images and containers"
	@echo "  make k8s-deploy Deploy app to Minikube (coming soon)"

# ---- Build ----
build:
	@echo "🚧 Building Docker image: $(IMAGE_NAME):$(IMAGE_TAG)"
	cd apps/api && $(DOCKER_CMD) build -t $(IMAGE_NAME):$(IMAGE_TAG) .

# ---- Run locally (with Infisical secrets) ----
run:
	@echo "🚀 Running container with Infisical secrets..."
	$(DOCKER_CMD) run -d --rm -p $(PORT):8000 --name $(APP_NAME) \
		--env-file <(infisical export --format=dotenv | sed "s/'//g") \
		$(IMAGE_NAME):$(IMAGE_TAG)

# ---- Stop ----
stop:
	@echo "🛑 Stopping running container..."
	-$(DOCKER_CMD) stop $(APP_NAME) || true

# ---- Scan image with Trivy ----
scan:
	@echo "🔍 Scanning image $(IMAGE_NAME):$(IMAGE_TAG) for vulnerabilities..."
	trivy image --scanners vuln $(IMAGE_NAME):$(IMAGE_TAG)

# ---- Clean up unused images ----
clean:
	@echo "🧹 Cleaning up unused Podman containers and images..."
	-$(DOCKER_CMD) system prune -af

# ---- Future target: Deploy to Minikube ----
k8s-deploy:
	@echo "🚢 Deploying $(APP_NAME) to Minikube..."
	@echo "Coming soon: kubectl apply -f k8s/"

