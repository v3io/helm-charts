{{- define "postgres-configs.deployment.env" -}}
- name: PGDATA
  value: {{ default "/tmp/{{ .Release.Namespace }}" .Values.postgres.dataMountPath }}/data2
{{- end }}
