.. highlight:: console

Appendix J: Quality of Service
==============================

Offload of OVS quality of service (QoS) rate limiting is supported
when applied to VFs.

Minimum supported versions:

+-----------+-------------------------+
|           | Bit-Rate Limiting       |
+-----------+-------------------------+
| Kernel    | 5.2                     |
+-----------+-------------------------+
| Firmware  | AOTC-2.10.A.38          |
+-----------+-------------------------+
| OVS       | 2.12                    |
+-----------+-------------------------+
| RHEL 7    | Not Supported           |
+-----------+-------------------------+
| RHEL 8    | 8.2                     |
+-----------+-------------------------+
| Ubuntu    | 20.04                   |
+-----------+-------------------------+

Configuring Quality of Service (QoS) Rate Limiting with OVS
-----------------------------------------------------------

OVS has support for using policing to enforce a ingress rate limit in
kilobits per second. For example, to set a rate limit of ``1000`` *kbps*
with of burst of ``100`` *kbps* on ``enp3s0v0``, use these commands to
set the rate limit for the VF corresponding to VF representor ``eth4``::

    # ovs-vsctl set interface eth4 ingress_policing_rate=1000
    # ovs-vsctl set interface eth4 ingress_policing_burst=100

The following command may be used to check the current rate limit
configuration in OVSDB::

    # ovs-vsctl list interface eth4 | grep ingress_policing
    ingress_policing_burst: 100
    ingress_policing_rate: 1000

The following command may be used to check the current rate limit
configuration in the kernel and offload hardware::

    # tc -s -d filter show dev eth4 ingress
    filter protocol all pref 1 matchall chain 0
    filter protocol all pref 1 matchall chain 0 handle 0x1
      in_hw (rule hit 2)
        action order 1:  police 0x2 rate 1Mbit burst 1600b mtu 64Kb
          action drop/continue overhead 0b linklayer unspec
        ref 1 bind 1 installed 226 sec used 0 sec
        Action statistics:
        Sent 260 bytes 4 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 112 bytes 2 pkt
        Sent hardware 148 bytes 2 pkt
        backlog 0b 0p requeues 0
