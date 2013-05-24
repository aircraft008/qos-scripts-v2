qos-scripts-v2
==============

This repository contains some fixes developped for the OpenWRT QOS Scripts
package.

Queues can be still be configured as presented here
[http://wiki.openwrt.org/doc/uci/qos].


Installation
==============

In order to install use scp to copy the files to your OpenWRT router.

scp -P 22 qos root@router:/etc/config/
scp -P 22 tcrules.awk root@router:/usr/lib/qos/
scp -P 22 generate.sh root@router:/usr/lib/qos/
ssh -p 22 -l root router "/etc/init.d/qos restart"

Custom Queues
==============

The "qos" file contains a sample setup which will work out of the box. However,
if you wish to customize it the following should be kept in mind.

*The "packetsize" argument has no use anymore (initial logic was broken).
*Ditto for "maxsize".
*The "packetdelay" argument does not delay packets, but instead delays the
traffic shaping action by a specified time in milliseconds.
*The "priority" determines the percentage of bandwidth to allocate to the m2
parameter of the HSFC SL Service Curve (as a rule of thumb set to the same value
as "avgrate").
