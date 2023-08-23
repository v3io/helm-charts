{{/* vim: set filetype=mustache: */}}

{{/*
Selector labels
*/}}
{{- define "v3io-keycloak.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: keycloak
release: {{ .Release.Name }}
{{- end -}}

{{/*
Labels
*/}}
{{- define "v3io-keycloak.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{ include "v3io-keycloak.selectorLabels" . }}
{{- end -}}

{{- define "v3io-keycloak.masterPassword" -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace .Values.keycloak.auth.existingSecret -}}
{{- if $secret -}}
{{/*
   Reusing existing password
*/}}
{{ $secret.data.masterPassword | b64dec }}
{{- else -}}
{{/*
    Generate new password
*/}}
{{- randAlphaNum 24 | nospace -}}
{{- end -}}
{{- end -}}

{{- define "v3io-keycloak.dbUser" -}}
keycloak-admin
{{- end -}}

{{- define "v3io-keycloak.dbPassword" -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace .Values.keycloak.externalDatabase.existingSecret -}}
{{- if $secret -}}
{{/*
   Reusing existing password
*/}}
{{ $secret.data.DB_PASSWORD | b64dec }}
{{- else -}}
{{/*
    Generate new password
*/}}
{{- randAlphaNum 24 | nospace -}}
{{- end -}}
{{- end -}}
