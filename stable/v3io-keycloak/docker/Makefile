KEYCLOAK_IMAGE_VERSION ?= 26.3.3-debian-12-r0
KEYCLOAK_IMAGE_NAME ?= gcr.io/iguazio/keycloak

.PHONY: build
build:
	docker buildx build --platform linux/amd64 \
		--build-arg KEYCLOAK_IMAGE_VERSION=$(KEYCLOAK_IMAGE_VERSION) \
		-t $(KEYCLOAK_IMAGE_NAME):$(KEYCLOAK_IMAGE_VERSION) \
		.
