{{- define "v3io-configs.java.core-site.xml" -}}
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>v3io:////</value>
  </property>
  <property>
    <name>fs.v3io.impl</name>
    <value>io.iguaz.v3io.hcfs.V3IOFileSystem</value>
  </property>
  <property>
    <name>fs.AbstractFileSystem.v3io.impl</name>
    <value>io.iguaz.v3io.hcfs.V3IOAbstractFileSystem</value>
  </property>
  <property>
    <name>new-daemon</name>
    <value>true</value>
  </property>
</configuration>
{{- end -}}

{{- define "v3io-configs.java.v3io.conf" -}}
v3io.client {
    socket.host=CURRENT_NODE_IP
    session.use-system-user=false
}
v3io.config.auth.file={{ default "/igz/java/auth" .Values.global.v3io.authPath }}/{{ default ".java" .Values.global.v3io.authFileName }}
new-daemon=true
{{- end -}}

{{- define "v3io-configs.java.configMap" -}}
{{ default "v3io.conf" .Values.global.v3io.configFileName }}: |
{{ include "v3io-configs.java.v3io.conf" . | indent 2}}

core-site.xml: |
{{ include "v3io-configs.java.core-site.xml" . | indent 2}}
{{- end -}}

{{- define "v3io-configs.java.v3io.secret.conf" -}}
v3io {
  client {
    session {
{{- if .Values.v3io.username }}
      user = {{ .Values.v3io.username | quote }}
{{- end }}
{{- if .Values.v3io.tenant }}
      tenant = {{ .Values.v3io.tenant | quote }}
{{- end }}
{{- if .Values.v3io.password }}
      password = {{ .Values.v3io.password | b64enc | quote }}
{{- end }}
{{- if .Values.v3io.accessKey }}
      access-key = {{ .Values.v3io.accessKey | quote }}
{{- end }}
    }
  }
}
{{- end -}}

{{- define "v3io-configs.java.secret" -}}
{{ default ".java" .Values.global.v3io.authFileName }}: {{ include "v3io-configs.java.v3io.secret.conf" . | b64enc | quote }}
{{- end -}}