{{- define "mysql-configs.deployment.env" -}}
- name: MYSQL_ALLOW_EMPTY_PASSWORD
  value: {{ default true .Values.mysql.allowEmptyPassword | quote }}
{{- end }}
