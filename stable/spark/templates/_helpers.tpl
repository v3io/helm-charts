{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 -}}
{{- end -}}

{{/*
Create fully qualified names.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "master-fullname" -}}
{{- $name := default .Chart.Name -}}
{{- printf "%s-master-%s" .Release.Name $name | trunc 32 -}}
{{- end -}}

{{- define "webui-fullname" -}}
{{- $name := default .Chart.Name -}}
{{- printf "%s-webui-%s" .Release.Name $name | trunc 32 -}}
{{- end -}}

{{- define "worker-fullname" -}}
{{- $name := default .Chart.Name -}}
{{- printf "%s-worker-%s" .Release.Name $name | trunc 32 -}}
{{- end -}}

{{- define "zeppelin-fullname" -}}
{{- $name := default .Chart.Name -}}
{{- printf "%s-zeppelin-%s" .Release.Name $name | trunc 32 -}}
{{- end -}}

{{- define "spark.registry" }}
{{- $service := default (list .Release.Name "-registry" | join "") .Values.v3io.daemonLookupService.name }}
{{- printf "http://%s:%.0f/%s" $service .Values.v3io.daemonLookupService.servicePort .Values.v3io.daemonLookupService.path}}
{{- end -}}}}
