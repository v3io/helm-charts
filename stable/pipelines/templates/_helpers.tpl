{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pipelines.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "api-server.name" -}}
{{- default "%s-%s" .Release.Name "api-server"}}
{{- end -}}
{{- define "workflow-controller.name" -}}
{{- printf "%s-%s" .Release.Name "workflow-controller" -}}
{{- end -}}
{{- define "agro.name" -}}
{{- printf "%s-%s" .Release.Name "agro" -}}
{{- end -}}
{{- define "persistenceagent.name" -}}
{{- default "%s-%s" .Release.Name "persistenceagent" -}}
{{- end -}}
{{- define "pipeline-runner.name" -}}
{{- printf "%s-%s" .Release.Name "pipeline-runner" -}}
{{- end -}}
{{- define "scheduledworkflow.name" -}}
{{- default "%s-%s" .Release.Name "scheduledworkflow" -}}
{{- end -}}
{{- define "ui.name" -}}
{{- default "%s-%s" .Release.Name "ui" -}}
{{- end -}}
{{- define "viewer-crd.name" -}}
{{- default "%s-%s" .Release.Name "viewer-crd" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pipelines.fullname" -}}
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
{{- define "pipelines.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Allow overriding of service accounts.
*/}}
{{- define "apiserver.serviceAccountName" -}}
{{- default .Chart.Name .Values.rbac.apiserver.serviceAccountName -}}
{{- end -}}
{{- define "persistenceagent.serviceAccountName" -}}
{{- default .Chart.Name .Values.rbac.persistenceagent.serviceAccountName -}}
{{- end -}}
{{- define "pipelinerunner.serviceAccountName" -}}
{{- default .Chart.Name .Values.rbac.pipeline-runner.serviceAccountName -}}
{{- end -}}
{{- define "scheduledworkflow.serviceAccountName" -}}
{{- default .Chart.Name .Values.rbac.scheduledworkflow.serviceAccountName -}}
{{- end -}}
{{- define "ui.serviceAccountName" -}}
{{- default .Chart.Name .Values.rbac.ui.serviceAccountName -}}
{{- end -}}
{{- define "viewercrd.serviceAccountName" -}}
{{- default .Chart.Name .Values.rbac.viewercrd.serviceAccountName -}}
{{- end -}}
