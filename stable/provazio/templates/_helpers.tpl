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

{{/*
Return the appropriate apiVersion for CRD APIs.
*/}}
{{- define "crd.apiVersion" -}}
{{- if semverCompare ">=1.19-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "apiextensions.k8s.io/v1" }}
{{- else -}}
{{- print "apiextensions.k8s.io/v1beta1" }}
{{- end -}}
{{- end -}}
