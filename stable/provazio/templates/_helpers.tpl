{{- define "provazio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "provazio.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "provazio.dashboard.name" -}}
{{- printf "%s-dashboard" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "provazio.controller.name" -}}
{{- printf "%s-controller" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "provazio.vault.name" -}}
{{- printf "%s-vault" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "provazio.provctl.name" -}}
{{- printf "%s-provctl" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  SA name for provctl Job pods (dashboard env spec provisioning.service_account_name).
  Precedence: useProvctlServiceAccount -> provctl.serviceAccountName -> legacy envSpec field -> omit (default SA).
*/}}
{{- define "provazio.provctl.jobServiceAccountName" -}}
{{- if .Values.provctl.useProvctlServiceAccount -}}
{{- include "provazio.provctl.name" . -}}
{{- else if .Values.provctl.serviceAccountName -}}
{{- .Values.provctl.serviceAccountName -}}
{{- else if dig "provisioning" "service_account_name" "" .Values.dashboard.envSpec -}}
{{- dig "provisioning" "service_account_name" "" .Values.dashboard.envSpec -}}
{{- end -}}
{{- end -}}
