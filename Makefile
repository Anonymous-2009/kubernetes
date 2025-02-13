# =====================================================
# 🛠️ Makefile for managing Docker images & containers 🛠️
# =====================================================
#
# 👉 Available Commands:
#
# 📦 Build Images:
#   make build-client    → Build the client Docker image
#   make build-server    → Build the server Docker image
#   make build-all       → Build both client and server images
#
# 🚀 Run Containers:
#   make run-client      → Run the client container (port 4173)
#   make run-server      → Run the server container (port 3000)
#   make run-all         → Run both client & server containers
#
# 🛑 Stop Containers:
#   make stop-client     → Stop the running client container
#   make stop-server     → Stop the running server container
#   make stop-all        → Stop both client & server containers
#
# ⬆️ Push Images to Docker Hub:
#   make push-client     → Push client image to Docker Hub
#   make push-server     → Push server image to Docker Hub
#   make push-all        → Push both client & server images
#
# 🧹 Cleanup:
#   make clean           → Remove all stopped containers
#
# =====================================================

# Variables
CLIENT_IMAGE = anonymous2009/testing-client:v1
SERVER_IMAGE = anonymous2009/testing-server:v1
CLIENT_CONTAINER = client-container
SERVER_CONTAINER = server-container

# Build client image
build-client:
	docker build -t $(CLIENT_IMAGE) ./client

# Build server image
build-server:
	docker build -t $(SERVER_IMAGE) ./server

# Run client container
run-client: stop-client
	docker run -d --rm --name $(CLIENT_CONTAINER) -p 4173:4173 $(CLIENT_IMAGE)

# Run server container
run-server: stop-server
	docker run -d --rm --name $(SERVER_CONTAINER) -p 3000:3000 $(SERVER_IMAGE)

# Stop client container if running
stop-client:
	@if docker ps -q --filter "name=$(CLIENT_CONTAINER)" | grep -q .; then \
		echo "⚠️ Stopping client container..."; \
		docker stop $(CLIENT_CONTAINER); \
	fi

# Stop server container if running
stop-server:
	@if docker ps -q --filter "name=$(SERVER_CONTAINER)" | grep -q .; then \
		echo "⚠️ Stopping server container..."; \
		docker stop $(SERVER_CONTAINER); \
	fi

# Push client image to Docker Hub
push-client:
	docker push $(CLIENT_IMAGE)

# Push server image to Docker Hub
push-server:
	docker push $(SERVER_IMAGE)

# Stop all containers
stop-all: stop-client stop-server
	echo "✅ All containers stopped."

# Run both containers
run-all: run-server run-client
	echo "🚀 Both containers are running."

# Build both images
build-all: build-server build-client
	echo "✅ Both images built."

# Push both images to Docker Hub
push-all: push-server push-client
	echo "🚀 Both images pushed to Docker Hub."

# Remove all stopped containers
clean:
	docker system prune -f

