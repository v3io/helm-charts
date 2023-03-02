{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "v3io-mysql.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "v3io-mysql.persistence.v3io.subPath" -}}
{{- if .Values.v3io.username -}}
{{- printf "/%s/%s" .Values.v3io.username .Values.persistence.v3io.mountPath -}}
{{- else -}}
{{ .Values.persistence.v3io.mountPath }}
{{- end -}}
{{- end -}}


{{/*
Define admin creds secret
*/}}
{{- define "v3io-mysql.adminSecretName" -}}
{{- if .Values.adminSecret.name -}}
{{- .Values.adminSecret.name -}}
{{- else -}}
{{ include "v3io-mysql.fullname" . }}-admin-creds
{{- end -}}
{{- end -}}

{{/*
Define v3io fuse secret name
*/}}
{{- define "v3io-mysql.v3io.fuse.secret" -}}
{{- if .Values.v3io.createSecret -}}
{{ include "v3io-mysql.fullname" . }}-v3io-fuse
{{- else if .Values.v3io.secretName -}}
{{- .Values.v3io.secretName -}}
{{- else -}}
{{ .Release.Name }}-v3io-fuse
{{- end -}}
{{- end -}}

{{/*
Init Config Map Name
*/}}
{{- define "v3io-mysql.initConfigMapName" -}}
{{- printf "%s-init" (include "v3io-mysql.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "v3io-mysql.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ include "v3io-mysql.fullname" . }}
release: {{ .Release.Name }}
{{- end -}}


{{/*
Labels
*/}}
{{- define "v3io-mysql.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{ include "v3io-mysql.selectorLabels" . }}
{{- end -}}
