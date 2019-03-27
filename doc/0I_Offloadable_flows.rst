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

Supported tunnel vports:

- VXLAN tunnel vports are supported as of upstream Linux kernel v4.16 and
  OVS v2.8, RHEL/CentOS 7.5 and Ubuntu 18.04 LTS.

- Geneve tunnel vports are supported as of upstream Linux kernel v4.16
  and OVS v2.8, RHEL/CentOS 7.6 and Ubuntu 18.10.

- Support for Geneve options has been accepted for inclusion in upstream
  Linux kernel v4.19 and OVS v2.11. This is included in RHEL8+, support in
  CentOS and Ubuntu is pending.

UDP-based tunnel vports must use the default UDP port for the tunnel type:

- VXLAN: port 4789.
- Geneve: port 6801.

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

Using native Open vSwitch bonds
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

Configuring Linux bonds
~~~~~~~~~~~~~~~~~~~~~~~

From RHEL 8.0+ it is possible to configure standard Linux bonds and add them
to an Open vSwitch bridge for offloading. The process to create and use these
bonds are shown next.

First create a bond::

    # ip link add bond0 type bond

Add the mac-representor ports to the bond::

    # ip link set dev ens1np0 master bond0
    # ip link set dev ens1np1 master bond0

If they need to be removed from the bond::

    # ip link set dev ens1np0 nomaster
    # ip link set dev ens1np1 nomaster

Information about a Linux bond can be obtained by::

    # cat /proc/net/bonding/bond0

Example of the output from the above command:

.. code-block:: text

    Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

    Bonding Mode: load balancing (round-robin)
    MII Status: up
    MII Polling Interval (ms): 0
    Up Delay (ms): 0
    Down Delay (ms): 0

    Slave Interface: ens1np0
    MII Status: up
    Speed: 40000 Mbps
    Duplex: full
    Link Failure Count: 0
    Permanent HW addr: 00:15:4d:13:50:32
    Slave queue ID: 0

    Slave Interface: ens1np1
    MII Status: up
    Speed: 40000 Mbps
    Duplex: full
    Link Failure Count: 0
    Permanent HW addr: 00:15:4d:13:50:33
    Slave queue ID: 0

Not all bonding modes are supported for offloading. The currently supported
modes are active-backup and balance-xor. See below for more info
configuring each mode.

.. note::

    All slaves needs to be removed from a bond before the mode can be changed.

active-backup
+++++++++++++

This mode will send traffic on only one of the ports that are aggregated in
the bond. This mode is configured by executing::

    # ip link set dev bond0 down
    # ip link set dev ens1np0 nomaster bond0
    # ip link set dev ens1np1 nomaster bond0
    # ip link set dev bond0 type bond mode active-backup
    # ip link set dev bond0 type bond miimon 100
    # ip link set dev ens1np0 master bond0
    # ip link set dev ens1np1 master bond0
    # ip link set dev bond0 up

The ``miimon`` setting sets the interval on which the link state should be
monitored in milliseconds. If a port down state is detected the bond will
reconfigure itself to send the traffic out on one of the other ports
in the bond.

balance-xor
+++++++++++

This mode balances traffic across the aggregated ports using a hash method.
To enable offloading the ``xmit_hash_policy`` value must be set to either
``layer3+4`` or ``encap3+4``. Other hashing methods will not be offloaded.
Configuration is as follows::


    # ip link set dev bond0 down
    # ip link set dev ens1np0 nomaster
    # ip link set dev ens1np1 nomaster
    # ip link set dev bond0 type bond mode balance-xor
    # ip link set dev bond0 type bond miimon 100

To use ``layer3+4`` as hash::

    # ip link set dev bond0 type bond xmit_hash_policy layer3+4

To use ``encap3+4`` as hash::

    # ip link set dev bond0 type bond xmit_hash_policy encap3+4

Add back the slave ports and up the bond::

    # ip link set dev ens1np0 master bond0
    # ip link set dev ens1np1 master bond0
    # ip link set dev bond0 up

For more detailed information on the difference between the
modes and the hash methods it is recommended to read the Linux kernel
`documentation <https://www.kernel.org/doc/Documentation/networking/bonding.txt>`_
on the subject.

Configuring Linux teaming
~~~~~~~~~~~~~~~~~~~~~~~~~

Another method of setting up link aggregated ports is to use Linux teaming.
Teaming is controlled using the ``teamd`` and ``teamdctl`` utilities, as
will be demonstrated below.

Creating a new team device for active-backup mode::

    # teamd -t bond0 -d -c '{"runner": {"name": "activebackup"}}'

Creating a new team device for load balancing mode. The hashing method for
teaming is not as well defined so for offloading to the NFP this will hash on
L3 and L4::

    # teamd -t bond0 -d -c '{"runner": {"name": "lacp"}}'

Ports are added using ``teamdctl``::

    # teamdctl bond0 port add ens6np0
    # teamdctl bond0 port add ens6np1

The port config can be dumped using::

    # teamdctl bond0 config dump

Example output:

.. code-block:: text

    {
        "device": "bond0",
        "ports": {
            "ens6np0": {
                "link_watch": {
                    "name": "ethtool"
                }
            },
            "ens6np1": {
                "link_watch": {
                    "name": "ethtool"
                }
            }
        },
        "runner": {
            "name": "lacp",
            "tx_hash": [
                "eth",
                "ipv4",
                "ipv6"
            ]
        }
    }

For more usage instructions using teaming take a look at the man
pages for ``teamd`` and ``teamdctl``.

Using Linux bonds/teaming with Open vSwitch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once the bond is configured as shown in section
:ref:`0I_Offloadable_flows:Configuring Linux bonds`
it is possible to use it with Open vSwitch, by adding the bond port to the
bridge as with any other type of port. See the following example which adds a
bridge, configures the bond port as well as a VF representor port and then adds
two simple flow rules that forwards all traffic between the VF and the bond::

    # ovs-vsctl add-br br0
    # ovs-vsctl add-port br0 bond0
    # ovs-vsctl add-port br0 vf0_repr
    # ovs-ofctl add-flow br0 in_port=bond0,actions=output:vf0_repr
    # ovs-ofctl add-flow br0 in_port=vf0_repr,actions=output:bond0

Teams are used with Open vSwitch in exactly the same way as bonds.

.. note::

    Currently it is not possible to use bonding in conjunction with any of the
    tunneling protocols.
