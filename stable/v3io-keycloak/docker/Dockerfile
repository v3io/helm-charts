ARG KEYCLOAK_IMAGE_VERSION=20.0.5-debian-11-r6

FROM bitnami/keycloak:${KEYCLOAK_IMAGE_VERSION}

ADD 0_startup_auth-path.sh /docker-entrypoint-initdb.d/0_startup_auth-path.sh
ADD libkeycloak.sh /opt/bitnami/scripts/libkeycloak.sh