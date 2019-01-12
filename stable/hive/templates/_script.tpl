{{- define "hive.script.config" -}}

V3IO_HIVE_CONFIG={{ default "/igz/hive/conf" .Values.hive.configPath }}
mkdir -p $V3IO_HIVE_CONFIG

cp -r $HIVE_HOME/conf/* $V3IO_HIVE_CONFIG/
cp {{ default "/etc/config/v3io" .Values.global.v3io.configMountPath }}/hive-site.xml $V3IO_HIVE_CONFIG/

sed -i "s/CURRENT_NODE_IP/$LOCAL_V3IOD/g" $V3IO_HIVE_CONFIG/hive-site.xml

# Hive Configuration Directory can be controlled by:
export HIVE_CONF_DIR=$V3IO_HIVE_CONFIG

{{- end -}}
