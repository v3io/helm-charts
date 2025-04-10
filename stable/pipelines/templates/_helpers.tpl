{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "pipelines.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pipelines.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "pipelines.commonLabels" -}}
app: {{ include "pipelines.name" . }}
chart: {{ include "pipelines.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}

{{/*
DB run user
*/}}
{{- define "pipelines.db.DBRunUser" -}}
{{- if .Values.db.podSecurityContext.runAsUser }}
{{- .Values.db.podSecurityContext.runAsUser -}}
{{- else -}}
{{- print "root" -}}
{{- end -}}
{{- end -}}
