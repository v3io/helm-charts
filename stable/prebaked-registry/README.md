# Prebaked Docker Registry Helm Chart
See: https://github.com/helm/charts/blob/master/stable/docker-registry/README.md
Except we allow a value to disable /var/lib/registry volumeMount when using filesystem storage type, so the mount
will not remove the prebaked images. we treat this registry as non persistent in this form.
