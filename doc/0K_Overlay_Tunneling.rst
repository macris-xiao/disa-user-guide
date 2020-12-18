.. highlight:: console

Appendix K: Overlay Tunneling
=============================

VXLAN Tunnels
-------------

Minimum supported versions:

+-----------+-------------------------+
| Kernel    | 4.15                    |
+-----------+-------------------------+
| Firmware  | 0AOTC28A.5642           |
+-----------+-------------------------+
| OVS       | 2.8                     |
+-----------+-------------------------+
| RHEL 7    | 7.5                     |
+-----------+-------------------------+
| RHEL 8    | 8.0                     |
+-----------+-------------------------+
| Ubuntu    | 18.04 LTS               |
+-----------+-------------------------+

Offload of VXLAN Tunnels is supported when using UDP port 4789.

Add a VXLAN VTEP to an OVS bridge (in this case br0, assuming br0 already
has an attached SR-IOV VF representor) as follows::

    # ovs-vsctl add-port br0 vxlan0 -- set interface vxlan type=vxlan options:local_ip=(local_ip) options:remote_ip=(remote_ip) options:key=(tunnel_key)

The resultant flow can be seen by querying the VF representor's TC filter
(with remote and local underlay IPs on subnet 10.0.0.0/24 and a tunnel key
= 100)::

    # tc -s filter show ingress dev eth1
    ...
    in_hw in_hw_count 1
        action order 1: tunnel_key  set
        src_ip 10.0.0.2
        dst_ip 10.0.0.1
        key_id 100
    ...

GENEVE Tunnels
--------------

Minimum supported versions:

+-----------+-------------------------+------------------------+
|           | Without Options         | With Options           |
+-----------+-------------------------+------------------------+
| Kernel    | 4.16                    | 4.19                   |
+-----------+-------------------------+------------------------+
| Firmware  | AOTC-2.9.A.16           | AOTC-2.9.A.31          |
+-----------+-------------------------+------------------------+
| OVS       | 2.8                     | 2.11                   |
+-----------+-------------------------+------------------------+
| RHEL 7    | 7.6                     | 7.7                    |
+-----------+-------------------------+------------------------+
| RHEL 8    | 8.0                     | 8.0                    |
+-----------+-------------------------+------------------------+
| Ubuntu    | 18.10                   | 19.04                  |
+-----------+-------------------------+------------------------+

Offload of GENEVE Tunnels is supported when using UDP port 6801.

A GENEVE VTEP may be added to an OVS bridge in the same manner as a
VXLAN VTEP::

    # ovs-vsctl add-port br0 geneve0 -- set interface geneve type=geneve options:local_ip=(local_ip) options:remote_ip=(remote_ip) options:key=(tunnel_key)

The successfully offloaded flows can be queried in the VF
representors's TC filter as per the example given for VXLAN.

GRE Tunnels
-----------

Minimum supported versions:

+-----------+-------------------------+
| Kernel    | 5.3                     |
+-----------+-------------------------+
| Firmware  | 0AOTC28A.5642           |
+-----------+-------------------------+
| OVS       | 2.11                    |
+-----------+-------------------------+
| RHEL 7    | Not supported           |
+-----------+-------------------------+
| RHEL 8    | 8.2                     |
+-----------+-------------------------+
| Ubuntu    | 19.10                   |
+-----------+-------------------------+

A GRE VTEP may be added to an OVS bridge in the same manner as a
VXLAN or GENEVE VTEP::

    # ovs-vsctl add-port br0 gre0 -- set interface gre0 type=gre options:local_ip=(local_ip) options:remote_ip=(remote_ip) options:key=(tunnel_key)

The successfully offloaded flows can be queried in the VF
representors's TC filter as per the example given for VXLAN.
