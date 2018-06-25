{{/* vim: set filetype=mustache: */}}

{{/*
Create fully qualified names.
*/}}

{{- define "master-name" -}}
{{- printf "%s-master" .Release.Name | trunc 63 -}}
{{- end -}}

{{- define "webui-name" -}}
{{- printf "%s-webui" .Release.Name | trunc 63 -}}
{{- end -}}

{{- define "worker-name" -}}
{{- printf "%s-worker" .Release.Name | trunc 63 -}}
{{- end -}}

{{- define "zeppelin-name" -}}
{{- printf "%s-zeppelin" .Release.Name | trunc 63 -}}
{{- end -}}

{{- define "spark.registry" }}
{{- $service := default (list .Release.Name "-registry" | join "") .Values.v3io.lookupService.name }}
{{- printf "http://%s:%.0f/%s" $service .Values.v3io.lookupService.servicePort .Values.v3io.lookupService.path}}
{{- end -}}}}
