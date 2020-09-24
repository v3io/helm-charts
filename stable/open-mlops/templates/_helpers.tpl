{{/* vim: set filetype=mustache: */}}

{{/*
Create fully qualified names.
*/}}
{{- define "open-mlops.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "open-mlops.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := (include "open-mlops.name" .) -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "open-mlops.jupyter.fullname" -}}
{{- printf "%s-jupyter"  (include "open-mlops.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Copied over from mlrun chart to duplicate the logic without constraining the values
*/}}
{{- define "open-mlops.mlrun.api.fullname" -}}
{{- if .Values.mlrun.api.fullnameOverride -}}
{{- .Values.mlrun.api.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.mlrun.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.mlrun.api.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.mlrun.api.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Copied over from mlrun chart to duplicate the logic without constraining the values
*/}}
{{- define "open-mlops.mlrun.ui.fullname" -}}
{{- if .Values.mlrun.ui.fullnameOverride -}}
{{- .Values.mlrun.ui.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.mlrun.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.mlrun.ui.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.mlrun.ui.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "open-mlops.mlrun.api.port" -}}
{{- .Values.mlrun.api.service.port | int -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "open-mlops.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
