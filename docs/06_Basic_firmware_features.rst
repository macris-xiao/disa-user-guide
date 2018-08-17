.. highlight:: console

Basic Firmware Features
=======================

In this section ``ethtool`` will be used to view and configure SmartNIC
interface parameters.

View Interface Parameters
-------------------------

The ``-k`` flag can be used to view current interface configurations. For
example, using a Agilio CX 1x40GbE NIC with a physical port representor
``enp4s0np0``::

    # ethtool -k enp4s0np0
    Features for enp4s0np0:
    rx-checksumming: off [fixed]
    tx-checksumming: off
    tx-checksum-ipv4: off [fixed]
    tx-checksum-ip-generic: off [fixed]
    tx-checksum-ipv6: off [fixed]
    tx-checksum-fcoe-crc: off [fixed]
    tx-checksum-sctp: off [fixed]
    scatter-gather: off
    tx-scatter-gather: off [fixed]
    tx-scatter-gather-fraglist: off [fixed]
    tcp-segmentation-offload: off
    tx-tcp-segmentation: off [fixed]
    tx-tcp-ecn-segmentation: off [fixed]
    tx-tcp6-segmentation: off [fixed]
    tx-tcp-mangleid-segmentation: off [fixed]
    udp-fragmentation-offload: off [fixed]
    generic-segmentation-offload: off [requested on]
    generic-receive-offload: on
    large-receive-offload: off [fixed]
    rx-vlan-offload: off [fixed]
    tx-vlan-offload: off [fixed]
    ntuple-filters: off [fixed]
    receive-hashing: off [fixed]
    highdma: off [fixed]
    rx-vlan-filter: off [fixed]
    vlan-challenged: off [fixed]
    tx-lockless: off [fixed]
    netns-local: off [fixed]
    tx-gso-robust: off [fixed]
    tx-fcoe-segmentation: off [fixed]
    tx-gre-segmentation: off [fixed]
    tx-ipip-segmentation: off [fixed]
    tx-sit-segmentation: off [fixed]
    tx-udp_tnl-segmentation: off [fixed]
    fcoe-mtu: off [fixed]
    tx-nocache-copy: off
    loopback: off [fixed]
    rx-fcs: off [fixed]
    rx-all: off [fixed]
    tx-vlan-stag-hw-insert: off [fixed]
    rx-vlan-stag-hw-parse: off [fixed]
    rx-vlan-stag-filter: off [fixed]
    busy-poll: off [fixed]
    tx-gre-csum-segmentation: off [fixed]
    tx-udp_tnl-csum-segmentation: off [fixed]
    tx-gso-partial: off [fixed]
    tx-sctp-segmentation: off [fixed]
    l2-fwd-offload: off [fixed]
    hw-tc-offload: on
    rx-udp_tunnel-port-offload: off [fixed]

Setting Interface Settings
--------------------------

Unless otherwise stated, changing the interface settings detailed below will
not require reloading of the NFP drivers for changes to take effect, unlike the
interface breakouts described in :ref:`05_Using_linux_driver:Configuring
Interface Media Mode`. If the interface has more than one physical port,
changes **must be** applied to the physical function *netdev* and those
settings will reflect on both ports. Unlike the basic CoreNIC firmware, each
physical port on the interface cannot be configured independently and
attempting to do so will produce an error. In this section, ``ens3`` will be
used as an example of a physical function *netdev*.

Receive Checksum Offload
````````````````````````

When enabled, checksum calculation and error checking comparison for received
packets is offloaded to the NFP SmartNIC's flow processor rather than the host
CPU.

To enable receive checksum offload::

    # ethtool -K ens3 rx on

To disable receive checksum offload::

    # ethtool -K ens3 rx off

Transmit Checksum Offload
`````````````````````````

When enabled, checksum calculation for outgoing packets is offloaded to the NFP
SmartNIC's flow processor rather than the host's CPU.

To enable transmit checksum offload::

    # ethtool -K ens3 tx on

To disable transmit checksum offload::

    # ethtool -K ens3 tx off

Scatter/Gather
``````````````

When enabled the NFP will use scatter/gather I/O, also known as Vectored
I/O, which allows a single procedure call to sequentially read data from
multiple buffers and write it to a single data stream. Only changes to the
scatter-gather interface settings (from ``on`` to ``off`` or ``off`` to ``on``)
will produce a terminal output as shown below::

    # ethtool -K ens3 sg on
    Actual changes:
    scatter-gather: on
            tx-scatter-gather: on
    generic-segmentation-offload: on

    # ethtool -K ens3 sg off
    Actual changes:
    scatter-gather: on
            tx-scatter-gather: on
    generic-segmentation-offload: on

TCP Segmentation Offload (TSO)
``````````````````````````````

When enabled, this parameter causes all functions related to the segmentation
of TCP packets at egress to be offloaded to the NFP.

To enable TCP segmentation offload::

    # ethtool -K ens3 tso on

To disable TCP segmentation offload::

    # ethtool -K ens3 tso off

Generic Segmentation Offload (GSO)
``````````````````````````````````

This parameter offloads segmentation for transport layer protocol data units
other than segments and datagrams for TCP/UDP respectively to the NFP. GSO
operates at packet egress.

To enable generic segmentation offload::

    # ethtool -K ens3 gso on

To disable generic segmentation offload::

    # ethtool -K ens3 gso off

Generic Receive Offload (GRO)
`````````````````````````````

This parameter enables software implementation of Large Receive Offload (LRO),
which aggregates multiple packets at ingress into a large buffer before they
are passed higher up the networking stack.

To enable generic receive offload::

    # ethtool -K ens3 gro on

To disable generic receive offload::

    # ethtool -K ens3 gro off

.. note::

    Take note that scripts that use ``ethtool -i ${INTERFACE}`` to get
    bus-info will not work on representors as this information is not populated
    for representor devices.
