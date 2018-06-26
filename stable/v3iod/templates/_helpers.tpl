{{/* vim: set filetype=mustache: */}}

{{/*
Create fully qualified names.
*/}}

{{- define "v3iod-name" -}}
{{- printf "%s-v3iod" .Release.Name | trunc 63 -}}
{{- end -}}

{{- define "v3iod-client-name" -}}
{{- printf "%s-v3iod-client" .Release.Name | trunc 63 -}}
{{- end -}}

{{- define "cache-name" -}}
{{- printf "%s-registry" .Release.Name | trunc 63 -}}
{{- end -}}
