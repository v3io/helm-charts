{{/* vim: set filetype=mustache: */}}

{{- define "demo-fullname" -}}
{{- printf "%s-demo" .Release.Name | trunc 24 -}}
{{- end -}}