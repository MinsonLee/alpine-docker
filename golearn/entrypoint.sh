#!/bin/sh
set -e

# 追加 hosts
curl -o /hosts.bak "https://raw.hellogithub.com/hosts"
cat /hosts.bak >> /etc/hosts

# 验证是否 ENTRYPOINT 的运行机制
touch /tmp/log
date >> /tmp/log

/bin/sh
