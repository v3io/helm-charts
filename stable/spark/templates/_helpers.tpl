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
{{- $name := default .Chart.Name .Values.Master.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{- define "webui-fullname" -}}
{{- $name := default .Chart.Name .Values.WebUi.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{- define "worker-fullname" -}}
{{- $name := default .Chart.Name .Values.Worker.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{- define "zeppelin-fullname" -}}
{{- $name := default .Chart.Name .Values.Zeppelin.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{- define "spark.registry" }}
{{- $host := default .Release.Name .Values.V3IO.DaemonLookupServiceHost }}
{{- printf "http://%s-%s:%.0f/%s" $host .Values.V3IO.DaemonLookupServiceName .Values.V3IO.DaemonLookupServicePort .Values.V3IO.DaemonLookupServicePath}}
{{- end -}}}}
