# Custom Keycloak Docker image

The keycloak chart we use here, uses a custom keycloak image by bitnami. This image is based on the official keycloak image, but adds some additional functionality.
However, the bitnami image has some hard coded configurations constraining the app to only use postgresql as a database. We need to use the mysql, so we can use a v3io fuse mount for the database persistency.

## Changes
The changes we made to the bitnami image are:
- Added startup script (`0_startup_auth-path.sh`) which sets the db according to the environment variable - `KEYCLOAK_DATABASE_VENDOR`
- Updated the bitnami `libkeycloak.sh`: 
  - Updated `keycloak_configure_database()` to use the `KEYCLOAK_DATABASE_VENDOR` variable to set the db type and set the db url and credentials accordingly.
  - Updated `keycloak_initialize()` to print log messages without explicitly mentioning postgres.

## Build
run the following command to build the image:
```bash
make build
```

