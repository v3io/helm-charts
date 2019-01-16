{{- define "hive.script.config" -}}

V3IO_HIVE_CONFIG={{ default "/igz/hive/conf-updated" .Values.hive.configPath }}
mkdir -p $V3IO_HIVE_CONFIG

cp -r $HIVE_HOME/conf/* $V3IO_HIVE_CONFIG/
cp {{ default "/etc/conf/v3io" .Values.global.v3io.configMountPath }}/hive-site.xml $V3IO_HIVE_CONFIG/

sed -i "s/HIVE_SERVICE_HOST/$HIVE_SERVICE_HOST/g" $V3IO_HIVE_CONFIG/hive-site.xml

# Initialize Hive metastore database
# 1. Check if schema does not exists or invalid, then try to initialize Hive metastore database schema
$HIVE_HOME/bin/schematool -dbType $HIVE_DB_TYPE -validate
if [ $? != 0 ]; then
  $HIVE_HOME/bin/schematool -initSchema -dbType $HIVE_DB_TYPE
fi

{{- end -}}
