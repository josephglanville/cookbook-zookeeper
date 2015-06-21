#!/bin/bash
. /etc/env_vars
CONFIG_TYPE=${CONFIG_TYPE:-"file"}

if [[ $CONFIG_TYPE == "s3" ]]; then
  if [[ -n ${AWS_ACCESS_KEY_ID} ]]; then
    TYPE_OPTS=" --configtype s3 --s3config ${S3_BUCKET}:${S3_PREFIX} \
      --s3credentials /etc/exhibitor/credentials.properties \
      --s3region ${S3_REGION} --s3backup true"
  else
      TYPE_OPTS="--configtype s3 --s3config ${S3_BUCKET}:${S3_PREFIX} \
      --s3region ${S3_REGION} --s3backup true"
  fi
elif [[ $CONFIG_TYPE == "file" ]]; then
    FS_CONFIG_DIR=${FS_CONFIG_DIR:="/var/lib/exhibitor"}
    TYPE_OPTS="--configtype file  --fsconfigdir ${FS_CONFIG_DIR}"
fi

EXHIBITOR_AUTH=${EXHIBITOR_AUTH:-"none"}
if [[ $EXHIBITOR_AUTH == "basic" ]]; then
    SECURITY_OPTS="--security /etc/exhibitor/web.xml \
        --realm exhibitor:/etc/exhibitor/realm \
        --remoteauth exhibitor:/etc/exhibitor/realm"
elif [[ $EXHIBITOR_AUTH == "none" ]]; then
    SECURITY_OPTS=""
fi

exec java -jar /opt/exhibitor/exhibitor.jar \
    --port ${PORT} --defaultconfig /etc/exhibitor/defaults.conf \
    --hostname ${HOSTNAME} ${TYPE_OPTS} ${SECURITY_OPTS}
