{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "netopsDemo.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "netopsDemo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "netopsDemo.generateName" -}}
{{- printf "%s-%s" .Release.Name "generate" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "netopsDemo.ingestName" -}}
{{- printf "%s-%s" .Release.Name "ingest" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "netopsDemo.projectName" -}}
{{- printf "%s-%s" .Release.Name "project" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
