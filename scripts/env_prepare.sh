#!/bin/sh

set -x

# install CNI plugins
find /etc/cni/net.d/ -type f -not -name fabedge.conflist -exec rm {} \;
cp -f /plugins/bin/bridge \
    /plugins/bin/host-local \
    /plugins/bin/loopback \
    /plugins/bin/portmap \
    /plugins/bin/bandwidth /opt/cni/bin

# cleanup flannel stuff
ip link delete cni0
ip link delete flannel.1
ip route | grep "flannel" |  while read dst via gw others; do ip route delete $dst via $gw; done
iptables -t nat -F POSTROUTING

exit 0
