{{- define "pvc.volumes" -}}
{{- if .Values.pvc.mounts }}
{{- range $pvcName, $mountPath := .Values.pvc.mounts }}
- name : {{ $pvcName }}-volume
  persistentVolumeClaim:
    claimName: {{ $pvcName }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "pvc.volumeMounts" -}}
{{- if .Values.pvc.mounts }}
{{- range $pvcName, $mountPath := .Values.pvc.mounts }}
- name: {{ $pvcName  }}-volume
  mountPath: {{ $mountPath | quote }}
{{- end }}
{{- end }}
{{- end -}}

