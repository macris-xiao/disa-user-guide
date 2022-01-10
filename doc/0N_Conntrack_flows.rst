.. highlight:: console

Appendix N: Updating NFP Conntrack flows
========================================

Conntrack flows may be offloaded to hardware if if they meet the criteria
described in this section

.. note::

   OVS TC conntrack is implemented in the host only, the firmware is not
   aware of any conntrack flows. BCLinux 8.2 is based on CentOS 8.3, so
   RHEL_MAJOR is 8 and RHEL_MINOR is 3 in BCLinux 8.2.

Minimal supported versions
--------------------------

+-------------+-------------------------+
| Kernel      | 5.9                     |
+-------------+-------------------------+
| OVS         | 2.13                    |
+-------------+-------------------------+
| CentOS      | 8.3                     |
+-------------+-------------------------+
| BCLinux     | 8.2                     |
+-------------+-------------------------+


Actions
-------

1. -trk/+trk:

   # This is indicating whether or not a flow is tracked by conntrack or not,
   # nothing to do with the connection state. All new packets entering will
   # be in the -trk state and needs to be send to conntrack with an action.
   # Once that has happened a packet will get the +trk state and can be
   # handled by the rest of the pipeline.

2. +new:

   # This is for new connections, if it's the first packet of a connection it
   # will go into this state, waiting for a packet in the return direction with
   # swapped 5-tuples fields.

3. +est:

   # This is when packets for both the forward and reverse directions have been
   # seen, and the connection state will go into the established state.


Configuring simplest conntrack flows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. flows for arp packets::

   $ table=0,in_port=[port_1],arp,actions=output:[port_2]
   $ table=0,in_port=[port_2],arp,actions=output:[port_1]

2. pre_ct flows::

   $ table=0,in_port=[port_1],ct_state=-trk,ip,actions=ct(table=1)
   $ table=0,in_port=[port_2],ct_state=-trk,ip,actions=ct(table=1)

New packets will hit the table 0 rules, which sends them to conntrack, and
recirculates them to table 1.

3. post_ct flows::

   $ table=1,in_port=[port_1],ct_state=+trk+new,ip,actions=ct(commit),output:[port_2]
   $ table=1,in_port=[port_2],ct_state=+trk+new,ip,actions=ct(commit),output:[port_1]
   $ table=1,in_port=[port_1],ct_state=+trk+est,ip,actions=output:[port_2]
   $ table=1,in_port=[port_2],ct_state=+trk+est,ip,actions=output:[port_1]

The conntrack state is added to the metadata, and it will hit +new or +est,
depending on the state when it went to through the kernel conntrack logic.
In the example above both directions have a +new entry, so any endpoint would
be able to start a new connection. If one would like only the endpoint on
[port_1] to be able to connect then the 'ct_state=+new+trk,ip,in_port=[port_2]'
needs to be removed.


Configuring IPv6 Conntrack flows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Match on different fields in -trk (L3 layer), +trk simple output, IPv6::

   $ table=0,icmp6,icmp_type=135,actions=NORMAL
   $ table=0,icmp6,icmp_type=136,actions=NORMAL
   # pre_ct flows
   $ table=0,in_port=[port_1],ct_state=-trk,ipv6,ipv6_src=[ipv6_1],actions=ct(table=1)
   $ table=0,in_port=[port_2],ct_state=-trk,ipv6,ipv6_src=[ipv6_2],actions=ct(table=1)
   # post_ct flows
   $ table=1,in_port=[port_1],ct_state=+trk+new,ipv6,actions=ct(commit),output:[port_2]
   $ table=1,in_port=[port_2],ct_state=+trk+new,ipv6,actions=ct(commit),output:[port_1]
   $ table=1,in_port=[port_1],ct_state=+trk+est,ipv6,actions=output:[port_2]
   $ table=1,in_port=[port_2],ct_state=+trk+est,ipv6,actions=output:[port_1]


Configuring Conntrack flows with vxlan tunnel
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# The configuration of OVS can refer ``Appendix I: Offloadable Flows``. The
# Conntrack flows of vxlan tunnel::

   $ table=0,in_port=[vxlan_port],ct_state=-trk,ip,actions=ct(table=1)
   $ table=0,in_port=[port_1],ct_state=-trk,ip,actions=ct(table=1)
   $ table=1,in_port=[vxlan_port],ct_state=+trk+new,ip,actions=ct(commit),output:[port_1]
   $ table=1,in_port=[port_1],ct_state=+trk+new,ip,actions=ct(commit),output:[vxlan_port]
   $ table=1,in_port=[vxlan_port],ct_state=+trk+est,ip,actions=output:[port_1]
   $ table=1,in_port=[port_1],ct_state=+trk+est,ip,actions=output:[vxlan_port]
