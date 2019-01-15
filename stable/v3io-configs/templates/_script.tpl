{{- define "v3io-configs.script.lookupService" -}}
{{- $service := "v3iod-locator" }}
{{- $port := 8080 }}
{{- $lookupPath := "locate/v3iod" }}
{{- if .Values.global.v3io.lookupService }}
{{- $service := default "v3iod-locator" .Values.global.v3io.lookupService.name }}
{{- $port := default 8080 (int .Values.global.v3io.lookupService.servicePort) }}
{{- $lookupPath := default "locate/v3iod" .Values.global.v3io.lookupService.path }}
LOOKUP_SERVICE={{ printf "%s:%d" $service $port}}
LOOKUP_URL="http://${LOOKUP_SERVICE}/{{ $lookupPath }}"
{{- else }}
{{- $service := "v3iod-locator" }}
{{- $port := 8080 }}
{{- $lookupPath := "locate/v3iod" }}
LOOKUP_SERVICE={{ printf "%s.%s.svc:%d" $service .Release.Namespace $port}}
LOOKUP_URL="http://${LOOKUP_SERVICE}/{{ $lookupPath }}"
{{- end }}
LOCAL_V3IOD=$(curl --silent --fail --connect-timeout 10 $LOOKUP_URL/$CURRENT_NODE_IP)

if [ "${LOCAL_V3IOD}" == "" ]; then
    echo "v3iod address is empty"
    exit 2
fi

mkdir -p {{ default "/igz/java/conf" .Values.global.v3io.configPath }}
cp {{ default "/etc/config/v3io" .Values.global.v3io.configMountPath }}/* {{ default "/igz/java/conf" .Values.global.v3io.configPath }}
sed -i "s/CURRENT_NODE_IP/$LOCAL_V3IOD/g" $IGZ_DATA_CONFIG_FILE
{{- end -}}
