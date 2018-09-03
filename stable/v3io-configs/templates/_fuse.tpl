{{- define "v3io-configs.fuse.secret" -}}
username: {{ .Values.v3io.username | b64enc | quote }}
tenant: {{ .Values.v3io.tenant | b64enc | quote }}
password: {{ .Values.v3io.password | b64enc | quote }}
{{- end -}}