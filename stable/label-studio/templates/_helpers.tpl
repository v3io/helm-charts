{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "label-studio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "label-studio.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "label-studio.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Allow overriding of service account and clusterrole names.
*/}}
{{- define "label-studio.serviceAccountName" -}}
{{- default (include "label-studio.fullname" .) .Values.rbac.serviceAccountName -}}
{{- end -}}

{{- define "label-studio.roleName" -}}
{{- default (include "label-studio.fullname" .) .Values.rbac.roleName -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "label-studio.common.labels" -}}
{{ include "label-studio.common.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/part-of: "label-studio"
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{/*
Common selector labels
*/}}
{{- define "label-studio.common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "label-studio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
