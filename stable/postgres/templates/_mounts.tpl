{{- define "postgres-configs.deployment.mount" -}}
{{- include "v3io-configs.deployment.mount" . }}
- name: pgdata
  hostPath:
    path: "/tmp/{{ .Release.Namespace }}/{{ .Release.Name }}/data"
{{- end -}}


{{- define "postgres-configs.deployment.volumeMounts" -}}
{{- include "v3io-configs.deployment.volumeMounts" . }}
- name: pgdata
  mountPath: {{ default "/tmp/{{ .Release.Namespace }}" .Values.postgres.dataMountPath }}
{{- end -}}
