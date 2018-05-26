{{/* vim: set filetype=mustache: */}}

{{/*
Create fully qualified names.
*/}}
{{- define "daemon-name" -}}
{{- $name := default .Chart.Name .Values.name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{- define "cache-name" -}}
{{- printf "%s-registry" .Release.Name -}}
{{- end -}}
