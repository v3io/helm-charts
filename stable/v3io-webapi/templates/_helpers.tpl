{{/* vim: set filetype=mustache: */}}

{{/*
Create fully qualified names.
*/}}
{{- define "webapi-name" -}}
{{- $name := default .Chart.Name .Values.name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}
