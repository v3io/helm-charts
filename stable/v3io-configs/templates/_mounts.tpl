{{- define "v3io-configs.deployment.mount" -}}
- name: shm
  hostPath:
    path: "/dev/shm/{{ .Release.Namespace }}"
- name: v3iod-comm
  hostPath:
    path: "/tmp/dayman/{{ .Release.Namespace }}"
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
  mountPath: {{ default "/etc/config/v3io" .Values.global.v3io.configMountPath }}
- name: v3io-auth
  mountPath: {{ default "/igz/java/auth" .Values.global.v3io.authPath }}
{{- end -}}

{{- define "v3io-configs.deployment.mount-with-fuse" -}}
{{- include "v3io-configs.deployment.mount" . }}
- name: v3io-fuse
  flexVolume:
    driver: "v3io/fuse"
    secretRef:
      name: {{ .Release.Name }}-v3io-fuse
{{- end -}}

{{- define "v3io-configs.deployment.volumeMounts-with-fuse" -}}
{{- include "v3io-configs.deployment.volumeMounts" . }}
- name: v3io-fuse
  mountPath: {{ default "/v3io" .Values.global.v3io.fusePath }}
{{- end -}}

{{- define "v3io-configs.deployment.mount-with-fuse-and-home" -}}
{{- include "v3io-configs.deployment.mount-with-fuse" . }}
{{- if .Values.v3io.username }}
- name: v3io-home
  flexVolume:
    driver: "v3io/fuse"
    secretRef:
      name: {{ .Release.Name }}-v3io-fuse
    options:
      container: {{ default "users" .Values.global.v3io.home.container }}
      subPath: {{ default "" .Values.global.v3io.home.pathPrefix }}/{{ .Values.v3io.username }}
{{- end }}
{{- end -}}

{{- define "v3io-configs.deployment.volumeMounts-with-fuse-and-home" -}}
{{- include "v3io-configs.deployment.volumeMounts-with-fuse" . }}
{{- if .Values.v3io.username }}
- name: v3io-home
  mountPath: {{ default "/User" .Values.global.v3io.home.mount }}
{{- end }}
{{- end -}}