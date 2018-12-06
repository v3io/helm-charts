{{- define "v3io-configs.fuse.secret" -}}
{{- if .Values.v3io.username }}
username: {{ .Values.v3io.username | b64enc | quote }}
{{- end  }}
{{- if .Values.v3io.tenant }}
tenant: {{ .Values.v3io.tenant | b64enc | quote }}
{{- end  }}
{{- if .Values.v3io.password }}
password: {{ .Values.v3io.password | b64enc | quote }}
{{- end  }}
{{- if .Values.v3io.accessKey }}
accessKey: {{ .Values.v3io.accessKey | b64enc | quote }}
{{- end  }}
{{- end -}}