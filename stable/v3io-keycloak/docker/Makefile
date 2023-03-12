KEYCLOAK_IMAGE_VERSION ?= 20.0.5-debian-11-r6
KEYCLOAK_IMAGE_NAME ?= gcr.io/iguazio/keycloak

.PHONY: build
build:
	docker build \
		--build-arg KEYCLOAK_IMAGE_VERSION=$(KEYCLOAK_IMAGE_VERSION) \
		-t $(KEYCLOAK_IMAGE_NAME):$(KEYCLOAK_IMAGE_VERSION) \
		.