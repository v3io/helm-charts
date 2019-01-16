{{- define "hive-config.deployment.env" -}}
- name: HIVE_CONF_DIR
  value: {{ default "/opt/hive/conf" .Values.hive.configPath }}
- name: HIVE_DB_TYPE
  value: {{ default "postgres" .Values.hive.databaseType }}
{{- end }}
