{{- define "mysql-configs.deployment.mount" -}}
{{- include "v3io-configs.deployment.mount" . }}
- name: mysql-data
  hostPath:
    path: "/tmp/{{ .Release.Namespace }}/{{ .Release.Name }}"
{{- end -}}


{{- define "mysql-configs.deployment.volumeMounts" -}}
{{- include "v3io-configs.deployment.volumeMounts" . }}
- name: mysql-data
  mountPath: {{ default "/tmp/{{ .Release.Namespace }}" .Values.mysql.dataMountPath }}
{{- end -}}
