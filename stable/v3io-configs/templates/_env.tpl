{{- define "v3io-configs.configPath" -}}
{{ default "/igz/java/conf" .Values.global.v3io.configPath }}/{{ default "v3io.conf" .Values.global.v3io.configFileName }}
{{- end -}}

{{- define "v3io-configs.deployment.env" -}}
- name: IGZ_DATA_CONFIG_FILE
  value: {{ include "v3io-configs.configPath" . }}
- name: CURRENT_NODE_IP
  valueFrom:
    fieldRef:
      fieldPath: status.hostIP
{{- end -}}