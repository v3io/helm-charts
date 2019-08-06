{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pipelines.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "api-server.name" -}}
{{- printf "%s-%s" .Release.Name "api-server" -}}
{{- end -}}
{{- define "workflow-controller.name" -}}
{{- printf "%s-%s" .Release.Name "workflow-controller" -}}
{{- end -}}
{{- define "argo.name" -}}
{{- printf "%s-%s" .Release.Name "argo" -}}
{{- end -}}
{{- define "persistenceagent.name" -}}
{{- printf "%s-%s" .Release.Name "persistenceagent" -}}
{{- end -}}
{{- define "pipeline-runner.name" -}}
{{- printf "%s-%s" .Release.Name "pipeline-runner" -}}
{{- end -}}
{{- define "scheduledworkflow.name" -}}
{{- printf "%s-%s" .Release.Name "scheduledworkflow" -}}
{{- end -}}
{{- define "ui.name" -}}
{{- printf "%s-%s" .Release.Name "ui" -}}
{{- end -}}
{{- define "viewer-crd.name" -}}
{{- printf "%s-%s" .Release.Name "viewer-crd" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pipelines.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
