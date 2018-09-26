.. highlight:: console

.. |br| raw:: html

    <br />

Appendix I: Offloadable Flows
=============================

Flows may be offloaded to hardware if they meet the criteria described in this
section.

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
    #. A VXLAN vport whose ingress packets are received on a physical port
       on an Agilio SmartNIC (flow rule must include outer IP addresses
       and use the default VXLAN port 4789) and whose egress action is to a
       VF port on an Agilio SmartNIC.

#. If present, the output action outputs to:

    #. A physical port or VF on the same Agilio SmartNIC as the input port or;
    #. A VXLAN vport whose egress packets are sent on a physical port
       of the same Agilio SmartNIC as the input port.

#. Only the input port or output port may be a VXLAN tunnel, not both.

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
|         | IPv6: Addresses                |
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

Bonds
-----

Flows resulting from the following modes could be accelerated:

+-----------------+--------------------+
| OVS Bonds Modes | Active Backup |br| |
|                 | Balance SLB |br|   |
|                 | Balance TCP        |
+-----------------+--------------------+

Configuring a bond in OVS in ``active-backup`` or ``balance-slb`` modes would
result in flows that are offloadable. It should be noted that OVS sends packets
to the LOCAL port for each bond. This results in flow rules that include
actions with output to the LOCAL port. This cannot be accelerated by Agilio
OVS. To prevent this from occurring, and to achieve acceleration, packets must
not be sent to the LOCAL port, which can be achieved by::

    # ovs-ofctl -O Openflow13 mod-port bondbr0 bondbr0 no-forward

Furthermore configuring a bond in ``balance-tcp`` mode could result in flows
that are offloadable if recirculation has been disabled. This can be achieved
using the following::

    # ovs-appctl dpif/set-dp-features bondbr0 recirc false

It should be noted that turning off recirculation leads to exact match datapath
entries (matching on L2, L3 and L4) being installed. e.g.

.. code-block:: text

    in_port(10),eth(src=12:23:34:45:56:67,dst=67:56:45:34:23:12),eth_type(0x0800),ipv4(src=10.10.10.10,dst=10.10.10.20,proto=6,frag=no),tcp(src=1000,dst=2000), packets:0, bytes:0, used:never, actions:6,7

This exact matching behavior leads to flow explosion, i.e. OVS will install an
entry for every unique (L2, L3 or L4) packet. This in turn could lead to
performance degradation, especially so when using many flows (100K and more).

Finally, OVS bonding is based on the NORMAL rule; links will not be aggregated
when the bond bridge does not contain a NORMAL rule. Should match/actions be
required, an additional bridge (named ``br0`` in this example) is required on
which the match/actions are performed, allowing the bond bridge to only have
the NORMAL rule. This additional bridge can be connected to the bond bridge
using a patch port.