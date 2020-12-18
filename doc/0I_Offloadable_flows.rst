.. highlight:: console

.. |br| raw:: html

    <br />

Appendix I: Offloadable Flows
=============================

Flows may be offloaded to hardware if they meet the criteria described in this
section.

.. note::

    The maximum number of flows that can be offloaded in RHEL 7.5/7.6 and
    Ubuntu 18.04 is 128k. This has been increased to 480k in kernel 4.20
    and has been backported to the 4.18-based kernel provided by RHEL 8.0.

Matches
-------

A flow may be offloaded if it matches only on the following fields:

+-----------+-------------------------------------------------+
| Metadata  | Input Port                                      |
+-----------+-------------------------------------------------+
| Layer 2   | Ethernet: Type, Addresses                       |
+-----------+-------------------------------------------------+
| VLAN:     | Outermost ID, Priority                          |
+-----------+-------------------------------------------------+
| Layer 3   | IPv4: Addresses, Protocol, TTL, TOS, Frag |br|  |
|           | IPv6: Addresses, Protocol, Hop Limit, TOS, Frag |
+-----------+-------------------------------------------------+
| Layer 4   | TCP: Ports, Flags |br|                          |
|           | UDP: Ports |br|                                 |
|           | SCTP: Ports                                     |
+-----------+-------------------------------------------------+
| Tunnel    | ID |br|                                         |
|           | IPv4: Outer Address |br|                        |
|           | UDP: Outer Destination Port                     |
+-----------+-------------------------------------------------+


Actions
-------

A flow may be offloaded if:

#. The input port of the flow is:

    #. A physical port or VF on an Agilio SmartNIC or;
    #. A supported tunnel vport whose ingress packets are received on a
       physical port on an Agilio SmartNIC and whose egress action is to a VF
       port on an Agilio SmartNIC.

#. If present, the output actions output to:

    #. A physical port or VF on the same Agilio SmartNIC as the input port or;
    #. A tunnel vport whose egress packets are sent on a physical port of the
       same Agilio SmartNIC as the input port.

#. Only the input port or output ports may be a tunnel vport, not both.

For information on supported tunnel vports please see
:ref:`0K_Overlay_Tunneling:Appendix K: Overlay Tunneling`

Offload of flows that output to more than one port is supported when using
OVS v2.10+, as found in the Fast Datapath repository for RHEL 7. Otherwise
only flows that output to at most one port may be offloaded.

Other than output and the implicit drop action, flows using the following
actions may be offloaded:

#. Push and Pop VLAN
#. Masked and Unmasked Set

Flows that include a masked set of any of the following fields may be
offloaded:

+---------+--------------------------------+
| Layer 2 | Ethernet: Type, Addresses |br| |
|         | VLAN: ID, Priority             |
+---------+--------------------------------+
| Layer 3 | IPv4: Addresses |br|           |
|         | IPv4: TTL, TOS  |br|           |
|         | IPv6: Addresses |br|           |
|         | IPv6: Hop Limit, priority      |
+---------+--------------------------------+
| Layer 4 | TCP: Ports |br|                |
|         | UDP: Ports                     |
+---------+--------------------------------+

Flows that include an unmasked set of any of the following fields may be
offloaded:

+--------+------------------------------+
| Tunnel | ID |br|                      |
|        | IPv4: Outer Address |br|     |
|        | UDP: Outer Destination Port  |
+--------+------------------------------+
