ARG KEYCLOAK_IMAGE_VERSION=20.0.5-debian-11-r6

# if it fails to build and you see this comment,
# then make sure that buildx is enabled on your docker env or run with `DOCKER_BUILDKIT=1 make build`
FROM --platform=${BUILDPLATFORM} bitnami/keycloak:${KEYCLOAK_IMAGE_VERSION}

ADD 0_startup_auth-path.sh /docker-entrypoint-initdb.d/0_startup_auth-path.sh
ADD libkeycloak.sh /opt/bitnami/scripts/libkeycloak.sh
