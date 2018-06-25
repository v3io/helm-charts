{{/* vim: set filetype=mustache: */}}

{{/*
Create fully qualified names.
*/}}

{{- define "v3io-webapi-name" -}}
{{- printf "%s-v3io-webapi" .Release.Name | trunc 63 -}}
{{- end -}}
