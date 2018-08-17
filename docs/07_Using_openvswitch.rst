.. highlight:: console

Using Open vSwitch
==================

Running Open vSwitch
--------------------

RHEL/CentOS 7.5
```````````````

Start Open vSwitch::

    # systemctl start openvswitch

Check status of Open vSwitch::

    # systemctl status openvswitch
    ● openvswitch.service - Open vSwitch
       Loaded: loaded (/usr/lib/systemd/system/openvswitch.service; enabled; vendor preset: disabled)
          Active: active (exited) since Mon 2018-05-07 11:18:16 SAST; 2min 13s ago
        Process: 130744 ExecStop=/bin/true (code=exited, status=0/SUCCESS)
        Process: 131101 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
       Main PID: 131101 (code=exited, status=0/SUCCESS)

      May 07 11:18:16 r730-dev-51 systemd[1]: Starting Open vSwitch...
      May 07 11:18:16 r730-dev-51 systemd[1]: Started Open vSwitch.

The *openvswitch* service controls the *ovsdb-server* and *ovs-vswitchd*
services. Check their status too::

    # systemctl status ovsdb-server
    ● ovsdb-server.service - Open vSwitch Database Unit
       Loaded: loaded (/usr/lib/systemd/system/ovsdb-server.service; static;
                          vendor preset: disabled)
       Active: active (running) since Mon 2018-05-07 11:18:16 SAST; 5min ago
     Process: 130869 ExecStop=/usr/share/openvswitch/scripts/ovs-ctl --no-ovs-vswitchd
       stop (code=exited, status=0/SUCCESS)
     Process: 130898 ExecStart=/usr/share/openvswitch/scripts/ovs-ctl --no-ovs-vswitchd
       --no-monitor --system-id=random --ovs-user=#{OVS_USER_ID} start $OPTIONS
     (code=exited, status=0/SUCCESS)
       Process: 130895 ExecStartPre=/usr/bin/chown #{OVS_USER_ID} /var/run/openvswitch
     (code=exited, status=0/SUCCESS)
    Main PID: 130939 (ovsdb-server)
       Tasks: 1
      CGroup: /system.slice/ovsdb-server.service
                 `-130939 ovsdb-server /etc/openvswitch/conf.db -vconsole:emer
                 -vsyslog:err -vfile:info --remote=punix:/var/run/openvswitch/db.sock...


                 May 07 11:18:16 r730-dev-51 systemd[1]: Starting Open vSwitch Database Unit...
                 May 07 11:18:16 r730-dev-51 runuser[130932]: pam_unix(runuser:session): sess...)
                 May 07 11:18:16 r730-dev-51 runuser[130932]: pam_unix(runuser:session): sess...h
                 May 07 11:18:16 r730-dev-51 runuser[130936]: pam_unix(runuser:session): sess...)
                 May 07 11:18:16 r730-dev-51 runuser[130936]: pam_unix(runuser:session): sess...h
                 May 07 11:18:16 r730-dev-51 ovs-ctl[130898]: Starting ovsdb-server [  OK  ]
                 May 07 11:18:16 r730-dev-51 ovs-vsctl[130940]: ovs|00001|vsctl|INFO|Called a...0
                 May 07 11:18:16 r730-dev-51 ovs-vsctl[130946]: ovs|00001|vsctl|INFO|Called as...
                 May 07 11:18:16 r730-dev-51 ovs-ctl[130898]: Configuring Open vSwitch system...]
                 May 07 11:18:16 r730-dev-51 systemd[1]: Started Open vSwitch Database Unit.
                 Hint: Some lines were ellipsized, use -l to show in full.

.. code-block:: console

    # systemctl status ovs-vswitchd
    ● ovs-vswitchd.service - Open vSwitch Forwarding Unit
       Loaded: loaded (/usr/lib/systemd/system/ovs-vswitchd.service; static;
                          vendor preset: disabled)
         Active: active (running) since Mon 2018-05-07 11:18:16 SAST; 6min ago
       Process: 130747 ExecStop=/usr/share/openvswitch/scripts/ovs-ctl --no-ovsdb-server stop
           (code=exited, status=0/SUCCESS)
       Process: 130955 ExecStart=/usr/share/openvswitch/scripts/ovs-ctl --no-ovsdb-server
           --no-monitor --system-id=random --ovs-user=#{OVS_USER_ID} start $OPTIONS
               (code=exited, status=0/SUCCESS)
       Process: 130952 ExecStartPre=/usr/bin/chmod 0775 /dev/hugepages
           (code=exited, status=0/SUCCESS)
       Process: 130949 ExecStartPre=/usr/bin/chown :hugetlbfs /dev/hugepages
           (code=exited, status=0/SUCCESS)
     Main PID: 130987 (ovs-vswitchd)
         Tasks: 50
       CGroup: /system.slice/ovs-vswitchd.service
                  `-130987 ovs-vswitchd unix:/var/run/openvswitch/db.sock -vconsole:emer
                  -vsyslog:err -vfile:info --mlockall --user openvswitch:huge...


                  May 07 11:18:16 r730-dev-51 systemd[1]: Starting Open vSwitch Forwarding Unit...
                  May 07 11:18:16 r730-dev-51 ovs-ctl[130955]: Starting ovs-vswitchd [  OK  ]
                  May 07 11:18:16 r730-dev-51 ovs-ctl[130955]: Enabling remote OVSDB managers ...]
                  May 07 11:18:16 r730-dev-51 systemd[1]: Started Open vSwitch Forwarding Unit.
                  Hint: Some lines were ellipsized, use -l to show in full

Enable Open vSwitch so that it will run on reboot::

    # systemctl enable openvswitch

Ubuntu 18.04 LTS
````````````````

Start Open vSwitch::

    # systemctl start openvswitch-switch

Check status of Open vSwitch::

    # systemctl status openvswitch-switch
    ● openvswitch-switch.service - Open vSwitch
       Loaded: loaded (/lib/systemd/system/openvswitch-switch.service; enabled; vend
          Active: active (exited) since Wed 2018-05-09 08:35:44 UTC; 20s ago
       Main PID: 1824 (code=exited, status=0/SUCCESS)
          Tasks: 0 (limit: 1153)
        CGroup: /system.slice/openvswitch-switch.service

The *openvswitch-vswitch* service controls the *ovsdb-server* and
*ovs-vswitchd* services. Check their status too::

    # systemctl status ovsdb-server
    ● ovsdb-server.service - Open vSwitch Database Unit
       Loaded: loaded (/lib/systemd/system/ovsdb-server.service; static; vendor pres
       Active: active (running) since Wed 2018-05-09 08:35:44 UTC; 1min 38s ago
        Tasks: 1 (limit: 1153)
       CGroup: /system.slice/ovsdb-server.service
                  └─1749 ovsdb-server /etc/openvswitch/conf.db -vconsole:emer -vsyslog:


    # systemctl status ovs-vswitchd
    ● ovs-vswitchd.service - Open vSwitch Forwarding Unit
       Loaded: loaded (/lib/systemd/system/ovs-vswitchd.service; static; vendor pres
       Active: active (running) since Wed 2018-05-09 08:35:44 UTC; 2min 6s ago
        Main PID: 1813 (ovs-vswitchd)
       Tasks: 1 (limit: 1153)
          CGroup: /system.slice/ovs-vswitchd.service
                     └─1813 ovs-vswitchd unix:/var/run/openvswitch/db.sock -vconsole:emer

Enable Open vSwitch so that it will run on reboot::

    # systemctl enable openvswitch-switch
    Synchronizing state of openvswitch-switch.service with SysV service script with /lib/systemd/systemd-sysv-install.
    Executing: /lib/systemd/systemd-sysv-install enable openvswitch-switch

Configuring Open vSwitch Hardware Offload
-----------------------------------------

To enable TC offloading in Open vSwitch, the ``hw-tc-offload`` flag for the
representors of any ports that will send or receive offloaded traffic
must be set to true. Unlike interface settings described in
:ref:`06_Basic_firmware_features:Setting Interface Settings` ``hw-tc-offload``
flags must be set for each physical port representor. Hardware TC offload is
enabled by default and can be verified for each port using ``ethtool``. Mote
that the PF interface won't show the ``hw-tc-offload`` flag being set by
default. For example::

    # ethtool -k ens3 | grep hw-tc-offload
    hw-tc-offload: on

The setting may be toggled for each port independently between on and off using
``ethtool``::

    # ethtool -K ens3np0 hw-tc-offload on

.. note::

    Hardware offload changes won't persist across reboots. The default setting
    for TC offloads when using the ``flower`` firmware is ``on``.

Configure Open vSwitch hardware offload::

    # ovs-vsctl set Open_vSwitch . other_config:hw-offload=true other_config:tc-policy=none

This change will persist across reboots. But, in the absence of a reboot, Open
vSwitch must be restarted:

In RHEL/CentOS 7.5 this is performed by the command::

    # systemctl restart openvswitch

In Ubuntu 18.04, the following command is used instead::

    # systemctl restart openvswitch-switch

Open vSwitch Hardware Offload Example
-------------------------------------

Create an Open vSwitch bridge and add two interfaces; the representors of the
first physical port and the VF. Please refer to section
:ref:`03_Driver_and_Firmware:SmartNIC Netdev Interfaces` for information on
*netdevs* of the SmartNICs and :ref:`05_Using_linux_driver:Configuring SR-IOV`
for creating VFs associated with a physical interface. The following example
requires at least one VF representor (in this case ``eth1``) associated with
the PF *netdev*.

Create an Open vSwitch bridge::

    # ovs-vsctl add-br br0

Add representor *netdev* for the first physical port to the bridge::

    # ovs-vsctl add-port br0 enp4s0np0

Add the representor *netdev* of the first VF to bridge::

    # ovs-vsctl add-port br0 eth1

The ``ovs-vsctl show`` command can be used to verify the config of the bridge,
and the kernel datapath can be verified with ``ovs-dpctl show``::

    # ovs-vsctl show
    5e9b8d4b-4a29-41af-92f1-3d9f161aa176
        Bridge "br0"
            Port "br0"
                Interface "br0"
                    type: internal
            Port "eth1"
                Interface "eth1"
            Port "enp4s0np0"
                Interface "enp4s0np0"
        ovs_version: "2.9.0"

    # ovs-dpctl show
    system@ovs-system:
      lookups: hit:19 missed:14 lost:0
      flows: 14
      masks: hit:84 total:5 hit/pkt:2.55
      port 0: ovs-system (internal)
      port 1: br0 (internal)
      port 2: enp4s0np0
      port 3: eth1

Packets should now be able to flow between the VF and the external port. The
view of Open vSwitch for offloaded and non-offloaded flows can be seen listed
using ``ovs-dpctl``. The port numbers used for ``in_port`` and the ``(output)``
actions correspond to those listed by ``ovs-dpctl`` show as shown above.

View offloaded datapath flows::

    # ovs-dpctl dump-flows type=offloaded
    in_port(2),eth(src=00:15:4d:0e:08:a7,dst=66:11:3e:c9:cf:2f),eth_type(0x0806), packets:2, bytes:92, used:187.890s, actions:3
    in_port(2),eth(src=00:15:4d:0e:08:a7,dst=66:11:3e:c9:cf:2f),eth_type(0x0800), packets:9, bytes:882, used:188.860s, actions:3
    ...

View non-offloaded datapath flows::

    # ovs-dpctl dump-flows type=ovs
    recirc_id(0),in_port(3),eth(src=66:11:3e:c9:cf:2f,dst=33:33:ff:c9:cf:2f),eth_type(0x86dd),ipv6(frag=no), packets:0, bytes:0, used:never, actions:1,2
    recirc_id(0),in_port(3),eth(src=66:11:3e:c9:cf:2f,dst=33:33:00:00:00:02),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:140, used:1399.137s, actions:1,2
    ...

View both offloaded and non-offloaded datapath flows::

    # ovs-dpctl dump-flows
    in_port(2),eth(src=00:15:4d:0e:08:a7,dst=66:11:3e:c9:cf:2f),eth_type(0x0806), packets:2, bytes:92, used:187.890s, actions:3
    in_port(2),eth(src=00:15:4d:0e:08:a7,dst=66:11:3e:c9:cf:2f),eth_type(0x0800), packets:9, bytes:882, used:188.860s, actions:3
    ...
    recirc_id(0),in_port(3),eth(src=66:11:3e:c9:cf:2f,dst=33:33:ff:c9:cf:2f),eth_type(0x86dd),ipv6(frag=no), packets:0, bytes:0, used:never, actions:1,2
    recirc_id(0),in_port(3),eth(src=66:11:3e:c9:cf:2f,dst=33:33:00:00:00:02),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:140, used:1399.137s, actions:1,2
    ...

.. note::

    Note that ``type=offloaded`` is just an indication that a flow is handled
    by the TC datapath. This does not guarantee that it has been offloaded to
    the SmartNIC, the TC commands shown next provides a much better indication.

The non-offloaded flows are present in the Open vSwitch kernel datapath. The
offloaded flows are present in hardware, and are configured by Open vSwitch via
the Kernel's TC subsystem. The kernel's view of these flows may be observed
using the ``tc`` command::

    # tc -s filter show ingress dev enp4s0np0
    filter protocol arp pref 1 flower
    filter protocol arp pref 1 flower handle 0x1
      dst_mac 66:11:3e:c9:cf:2f
      src_mac 00:15:4d:0e:08:a7
      eth_type arp
      not_in_hw
          action order 1: mirred (Egress Redirect to device eth1) stolen
          index 1 ref 1 bind 1 installed 409 sec used 187 sec
          Action statistics:
          Sent 92 bytes 2 pkt (dropped 0, overlimits 0 requeues 0)
          backlog 0b 0p requeues 0
          cookie len 16 e053c4819648461a

    filter protocol ip pref 2 flower
    filter protocol ip pref 2 flower handle 0x1
      dst_mac 66:11:3e:c9:cf:2f
      src_mac 00:15:4d:0e:08:a7
      eth_type ipv4
      in_hw
          action order 1: mirred (Egress Redirect to device eth1) stolen
          index 4 ref 1 bind 1 installed 409 sec used 188 sec
          Action statistics:
          Sent 882 bytes 9 pkt (dropped 0, overlimits 0 requeues 0)
          backlog 0b 0p requeues 0
          cookie len 16 b68ca7de9c465000

    # tc -s filter show ingress dev eth1
    filter protocol arp pref 1 flower
    filter protocol arp pref 1 flower handle 0x1
      dst_mac 00:15:4d:0e:08:a7
      src_mac 66:11:3e:c9:cf:2f
      eth_type arp
      not_in_hw
          action order 1: mirred (Egress Redirect to device enp4s0np0) stolen
          index 2 ref 1 bind 1 installed 409 sec used 187 sec
          Action statistics:
          Sent 56 bytes 2 pkt (dropped 0, overlimits 0 requeues 0)
          backlog 0b 0p requeues 0
          cookie len 16 5049f238734ef962

    filter protocol ip pref 2 flower
    filter protocol ip pref 2 flower handle 0x1
      dst_mac 00:15:4d:0e:08:a7
      src_mac 66:11:3e:c9:cf:2f
      eth_type ipv4
      in_hw
          action order 1: mirred (Egress Redirect to device enp4s0np0) stolen
          index 3 ref 1 bind 1 installed 409 sec used 188 sec
          Action statistics:
          Sent 882 bytes 9 pkt (dropped 0, overlimits 0 requeues 0)
          backlog 0b 0p requeues 0
          cookie len 16 3dae846e6b41a778
