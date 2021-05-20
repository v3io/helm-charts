{{/* vim: set filetype=mustache: */}}

{{/*
Create fully qualified names.
*/}}
{{- define "mlrun-kit.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mlrun-kit.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := (include "mlrun-kit.name" .) -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "mlrun-kit.shared-persistency-pvc.fullname" -}}
{{- if (index .Values.mlrun.api.extraPersistentVolumeMounts 0).existingClaim -}}
{{- (index .Values.mlrun.api.extraPersistentVolumeMounts 0).existingClaim -}}
{{- else -}}
{{- printf "%s-shared-pvc"  (include "mlrun-kit.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "mlrun-kit.jupyter.fullname" -}}
{{- printf "%s-jupyter"  (include "mlrun-kit.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mlrun-kit.jupyter.mlrunUIURL" -}}
{{- if .Values.jupyterNotebook.mlrunUIURL -}}
{{- .Values.jupyterNotebook.mlrunUIURL -}}
{{- else -}}
{{- printf "http://%s:%s" .Values.global.externalHostAddress (.Values.mlrun.ui.service.nodePort | toString) -}}
{{- end -}}
{{- end -}}


{{/*
Copied over from mlrun chart to duplicate the logic without constraining the values
*/}}
{{- define "mlrun-kit.mlrun.api.fullname" -}}
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
{{- define "mlrun-kit.mlrun.ui.fullname" -}}
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

{{- define "mlrun-kit.mlrun.api.port" -}}
{{- .Values.mlrun.api.service.port | int -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mlrun-kit.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
