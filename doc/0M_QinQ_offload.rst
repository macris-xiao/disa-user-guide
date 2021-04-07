.. highlight:: console

Appendix M: QinQ
================

Minimum supported versions:

+-----------+-------------------------+
|           | QinQ offload            |
+-----------+-------------------------+
| Kernel    | 5.10                    |
+-----------+-------------------------+
| Firmware  | AOTC-2.14.A.6           |
+-----------+-------------------------+
| OVS       | 2.11                    |
+-----------+-------------------------+
| RHEL 7    | Not Supported           |
+-----------+-------------------------+
| RHEL 8    | Not released yet        |
+-----------+-------------------------+
| Ubuntu    | Not released yet        |
+-----------+-------------------------+

Configuring QinQ in OVS
-----------------------

OVS has support to configure QinQ, previously known as 802.1ad. Support to
offload this had been added in the versions above. There are two ways to
configure this. The first is to use OVS port types together with the ``NORMAL``
rule. Enable the feature::

    $ ovs-vsctl set Open_vSwitch . other_config:vlan-limit=2

Next is to configure the port with ovs-vsctl to add a service tag (outer
VLAN) for specific customer tags (inner VLAN)::

    $ ovs-vsctl set port <phy0_repr> vlan_mode=dot1q-tunnel tag=2000 cvlans=100

As mentioned above, this only works when using action=NORMAL. An alternative
method is to use OpenFlow rules to push and pop VLAN tags, a lot similar to how
it would be done with just a single VLAN.

.. note::
    It is still required to set vlan-limit=2, even if using OpenFlow rules
    directly.

Adding a VLAN tag can be achieved with::

    $ ovs-ofctl add-flow br0 in_port=<repr 1> action=push_vlan:0x88a8,mod_vlan_vid=2000,output:<repr 2>

The above will push a tag with type 0x88a8, and vlan_id=2000 onto a packet. It
is also possible to push both an inner and outer VLAN tag in the same action::

    $ ovs-ofctl add-flow br0 in_port=<repr 1>,action=push_vlan:0x8100,mod_vlan_vid=200,push_vlan:0x88a8,mod_vlan_vid=2000,output:<repr 2>

This will push an inner tag of type 0x8100 and vlan_id 200, as well as outer
tag with type 0x88a8 and vlan_id 2000. This is a slightly unusual use case,
normally the traffic will already have an inner tag, and just the outer
tag needs to be pushed.

Removing a tag is quite easy::

    $ ovs-ofctl add-flow br0 in_port=<repr 2>,action=pop_vlan,output:<repr 1>

There is not any way to specify which tag needs to be stripped, so the pop_vlan
action will always remove the most outer VLAN. Once again it is possible to
remove both tags with a single rule, just chain the ``pop_vlan`` actions::

    $ ovs-ofctl add-flow br0 in_port=<repr 2>,action=pop_vlan,pop_vlan,output:<repr 1>

.. note::
    Only a maximum of two tags is supported for offloading. Another limitation
    is that while a single VLAN tag on the outside of a tunnel header is
    supported for offloading this is not supported with multiple tags.
