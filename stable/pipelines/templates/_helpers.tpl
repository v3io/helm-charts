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
Return the appropriate apiVersion for CRD APIs.
*/}}
{{- define "crd.apiVersion" -}}
{{- if semverCompare ">=1.16-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "apiextensions.k8s.io/v1" }}
{{- else -}}
{{- print "apiextensions.k8s.io/v1beta1" }}
{{- end -}}
{{- end -}}
