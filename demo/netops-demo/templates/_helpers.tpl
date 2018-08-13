{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "netops-demo.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "netops-demo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "netops-demo.generateName" -}}
{{- printf "%s-%s" .Release.Name "generate" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "netops-demo.ingestName" -}}
{{- printf "%s-%s" .Release.Name "ingest" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "netops-demo.projectName" -}}
{{- printf "%s-%s" .Release.Name "project" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
