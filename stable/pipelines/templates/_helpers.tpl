{{/* vim: set filetype=mustache: */}}
{{/*
The project uses hardcoded names for instance api server is mlpipelines.
If it's fixed in the future consider changing names
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "pipelines.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

