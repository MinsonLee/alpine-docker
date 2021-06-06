#!/bin/sh
set -e

# 追加 hosts
cat /hosts >> /etc/hosts

# 验证是否 ENTRYPOINT 的运行机制
touch /tmp/log
date >> /tmp/log

/bin/sh
