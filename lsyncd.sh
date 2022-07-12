#!/bin/sh
 
SOURCE_DIR=${SOURCE_DIR}
TARGET_DIR=${TARGET_DIR}
 
cat <<EOF >/etc/lsyncd.conf
settings {
  logfile = "/dev/stdout",
  statusFile = "/var/run/lsyncd.status",
  pidfile = "/var/run/lsyncd.pid",
  nodaemon = "true"
}
sync {
  default.rsync,
  delete = false,
  source = '${SOURCE_DIR}',
  target = '${TARGET_DIR}'
}
EOF

 
exec /usr/bin/lsyncd -nodaemon -delay 0 /etc/lsyncd.conf
