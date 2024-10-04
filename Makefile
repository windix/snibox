DOCKER_REPO ?= docker.lab.windix.au/snibox
DOCKER_TAG ?= sqlite-arm64

build:
	docker build -t ${DOCKER_REPO}:${DOCKER_TAG} .
	
push:
	docker push ${DOCKER_REPO}:${DOCKER_TAG}
