{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tsdb-functions.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tsdb-functions.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tsdb-functions.queryName" -}}
{{- printf "%s-%s" .Release.Name "query" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tsdb-functions.ingestName" -}}
{{- printf "%s-%s" .Release.Name "ingest" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tsdb-functions.projectName" -}}
{{- printf "tsdb-functions-%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
