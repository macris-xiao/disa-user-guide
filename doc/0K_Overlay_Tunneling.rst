.. highlight:: console

Appendix K: Overlay Tunneling
=============================

Introduction
------------

OVS-TC supports offloading tunnels. The supported tunnel types and the
corresponding minimum versions of the various components are documented below.
The OVS documentation can be referred to for more detailed information on how
OVS works with tunnels, and this section will only provide a short summary
of the two configurations for which offloading is supported.

Method 1: IP-on-the-Port
~~~~~~~~~~~~~~~~~~~~~~~~

This is the simplest method, where the tunnel IP is placed on the physical
port, and the port itself is not placed on the OVS bridge. The OVS bridge
contains the VF representor ports, as well as a tunnel port. OVS uses Linux
routing to be able to map the tunnel to the correct physical port, and uses
this information to generate a datapath rule which is offloaded.

The configuration of a tunnel port will vary slightly for the different port
types, refer to the specific tunnel sections below - for this section a
shortened format will be use to explain the concept. The steps to configure
this are as follows.

Configure the port IP address::

    $ ip addr add dev (phy0) (local_tun_ip/mask)
    $ ip link set dev (phy0) up

Configure the bridge::

    $ ovs-vsctl add-br br0
    $ ovs-vsctl add-port br0 vtep -- (vtep specific settings...)
    $ ovs-vsctl add-br br0 (vf0_repr)

This is all that is required to configure the underlay for successful
tunneling. A simple test would be to add an IP to the VF netdev (or interface
in the VM if that is used), and ping a VM/netdev on the remote machine,
something like this::

    $ ip addr add dev (vf0_netdev) (local_vm_ip/mask)
    $ ping (remote_vm_ip)

Method 2: IP-on-the-Bridge
~~~~~~~~~~~~~~~~~~~~~~~~~~

This is the method that is typically configured by OpenStack, and usually
involves two bridges. As the name suggests the tunnel IP in this case is placed
on the bridge port. A common convention is to have the two bridges called
``br-ex`` and ``br-int``. ``br-ex`` will have the physical port added to it,
and the IP will be placed on the ``br-ex`` port. ``br-int`` will be configured
exactly the same as ``br0`` in :ref:`0K_Overlay_Tunneling:Method 1:
IP-on-the-Port`.

Configure bridge ``br-ex``::

    $ ovs-vsctl add-br br-ex
    $ ovs-vsctl add-port br-ex (phy0)

    $ ip addr add dev br-ex (local_tun_ip/mask)
    $ ip link set dev br-ex up

Configure bridge ``br-int``::

    $ ovs-vsctl add-br br-int
    $ ovs-vsctl add-port br-int vtep -- (vtep specific settings...)
    $ ovs-vsctl add-br br-int (vf0_repr)

At this point the configuration is done, and can also be verified as explained
in :ref:`0K_Overlay_Tunneling:Method 1: IP-on-the-Port`.

.. note::
    For best behavior it is important that `action=NORMAL` is used on ``br-ex``.
    Any more specific rules are usually applied to ``br-int``.

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
