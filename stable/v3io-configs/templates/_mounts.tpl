{{- define "v3io-configs.deployment.mount" -}}
- name: shm
  hostPath:
    path: "/dev/shm"
- name: v3iod-comm
  hostPath:
    path: "/tmp/dayman"
- name: v3io-config
  configMap:
    name: {{ .Release.Name }}-v3io-config
- name: v3io-auth
  secret:
    secretName: {{ .Release.Name }}-v3io-auth
{{- end -}}

{{- define "v3io-configs.deployment.volumeMounts" -}}
- name: shm
  mountPath: "/dev/shm"
- name: v3iod-comm
  mountPath: "/tmp/dayman"
- name: v3io-config
  mountPath: {{ default "/igz/java/conf" .Values.global.v3io.configPath }}
- name: v3io-auth
  mountPath: {{ default "/igz/java/auth" .Values.global.v3io.authPath }}
{{- end -}}