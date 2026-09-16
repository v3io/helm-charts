{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "pipelines.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pipelines.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Deterministic suffix for the mysql-kf-fix-indices Job name, derived from every
input that shapes its pod template. Job pod templates are immutable, so a
back-to-back upgrade that reuses the same name with a changed pod template is
rejected with 409; hashing those inputs into the name means the name only
changes when the pod template would, avoiding both the conflict and the
generateName/blank-name issues that break kustomize and helm's own upgrade
diffing.
*/}}
{{- define "pipelines.mysqlFixIndicesJobHash" -}}
{{- $hashInput := dict
      "chartVersion" .Chart.Version
      "image" (printf "%s:%s" .Values.images.mysql.repository .Values.images.mysql.tag)
      "imagePullPolicy" .Values.images.imagePullPolicy
      "podSecurityContext" .Values.db.podSecurityContext
      "securityContext" .Values.db.securityContext
      "nodeSelector" .Values.nodeSelector
      "tolerations" .Values.tolerations
      "affinity" .Values.affinity
      "priorityClassName" .Values.priorityClassName
-}}
{{- toYaml $hashInput | sha256sum | trunc 8 -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "pipelines.commonLabels" -}}
app: {{ include "pipelines.name" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}

{{/*
Define mino storage secret name
*/}}
{{- define "pipelines.minioStorageSecretName" -}}
{{- if .Values.storageMode.minio.existingSecretName -}}
{{- .Values.storageMode.minio.existingSecretName -}}
{{- else -}}
{{- "mlpipeline-minio-artifact" -}}
{{- end -}}
{{- end -}}


{{/*
Define access key name for the minio secret
*/}}
{{- define "pipelines.minioAccessKeyName" -}}
{{- if .Values.storageMode.minio.accessKeyName -}}
{{- .Values.storageMode.minio.accessKeyName -}}
{{- else -}}
{{- "accesskey" -}}
{{- end -}}
{{- end -}}

{{/*
Define secret key name for the minio secret
*/}}
{{- define "pipelines.minioSecretKeyName" -}}
{{- if .Values.storageMode.minio.secretKeyName -}}
{{- .Values.storageMode.minio.secretKeyName -}}
{{- else -}}
{{- "secretkey" -}}
{{- end -}}
{{- end -}}


# define mysql secret name or use existing secret
{{- define "pipelines.dbSecretName" -}}
{{- if .Values.db.existingSecretName -}}
{{- .Values.db.existingSecretName -}}
{{- else -}}
{{- "mysql-kf-secret" -}}
{{- end -}}
{{- end -}}

{{/*
Render imagePullSecrets for ServiceAccounts from global values.
*/}}
{{- define "pipelines.imagePullSecrets" -}}
{{- $pullSecrets := list -}}
{{- range .Values.global.imagePullSecrets -}}
  {{- if kindIs "map" . -}}
    {{- $pullSecrets = append $pullSecrets .name -}}
  {{- else -}}
    {{- $pullSecrets = append $pullSecrets . -}}
  {{- end -}}
{{- end -}}
{{- if (not (empty $pullSecrets)) -}}
imagePullSecrets:
{{- range $pullSecrets | uniq }}
  - name: {{ . }}
{{- end -}}
{{- end -}}
{{- end -}}
