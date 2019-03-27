.. highlight:: console

Validating the Driver
=====================

The Netronome SmartNIC physical function driver with support for OVS-TC offload
is included in Linux 4.13 and later kernels. The list of minimum required
operating system distributions and their respective kernels which include the
*nfp* driver are as follows:

================ ======================
Operating System Kernel package version
================ ======================
RHEL/CentOS 7.5  ``3.10.0-862.el7``
RHEL/CentOS 7.6  ``3.10.0-957.el7``
RHEL 8.0         ``4.18.0-80.el8``
Ubuntu 18.04 LTS ``4.15.0-20.21``
================ ======================

.. note::

    Only the x86_64 architecture has been verified, if support for other
    architectures is required please contact Netronome support: :ref:`XX_contact_us:Contact Us`.

Confirm Upstreamed NFP Driver
-----------------------------

To confirm that your current operating system supplies the upstreamed *nfp*
module, you can use the ``modinfo`` command::

    # modinfo nfp | head -3
    filename:
    /lib/modules/3.10.0-862.el7/kernel/drivers/net/ethernet/netronome/nfp/nfp.ko.xz
    description:    The Netronome Flow Processor (NFP) driver.
    license:        GPL

.. note::
    If the module is not found in your current kernel, refer to
    :ref:`0C_Install_oot_nfp_driver:Appendix C: Installing the Out-of-Tree
    NFP Driver` for more instructions, or upgrade your distributions and kernel
    version to a version that includes the upstreamed drivers.

Confirm that the NFP Driver is Loaded
-------------------------------------

Use ``lsmod`` to list the loaded driver modules and look for the ``nfp``
string::

    # lsmod | grep nfp
    nfp                   161364  0

If the NFP driver is not loaded, the following command loads it manually::

    # modprobe nfp

Validating the Firmware
=======================

Netronome SmartNICs are fully programmable devices and depend on the driver to
load firmware onto the device at runtime. It is important to note that the
functionality of the SmartNIC significantly depends on the firmware loaded. The
firmware files should be present in the following directory (contents may vary
depending on the installed firmware and distribution layout)::

    # ls -ogR --time-style="+" /lib/firmware/netronome/
    /lib/firmware/netronome/:
    total 8
    drwxr-xr-x. 2 4096  flower
    drwxr-xr-x. 2 4096  nic
    lrwxrwxrwx  1   31  nic_AMDA0081-0001_1x40.nffw -> nic/nic_AMDA0081-0001_1x40.nffw
    lrwxrwxrwx  1   31  nic_AMDA0081-0001_4x10.nffw -> nic/nic_AMDA0081-0001_4x10.nffw
    lrwxrwxrwx  1   31  nic_AMDA0096-0001_2x10.nffw -> nic/nic_AMDA0096-0001_2x10.nffw
    lrwxrwxrwx  1   31  nic_AMDA0097-0001_2x40.nffw -> nic/nic_AMDA0097-0001_2x40.nffw
    lrwxrwxrwx  1   36  nic_AMDA0097-0001_4x10_1x40.nffw -> nic/nic_AMDA0097-0001_4x10_1x40.nffw
    lrwxrwxrwx  1   31  nic_AMDA0097-0001_8x10.nffw -> nic/nic_AMDA0097-0001_8x10.nffw
    lrwxrwxrwx  1   36  nic_AMDA0099-0001_1x10_1x25.nffw -> nic/nic_AMDA0099-0001_1x10_1x25.nffw
    lrwxrwxrwx  1   31  nic_AMDA0099-0001_2x10.nffw -> nic/nic_AMDA0099-0001_2x10.nffw
    lrwxrwxrwx  1   31  nic_AMDA0099-0001_2x25.nffw -> nic/nic_AMDA0099-0001_2x25.nffw
    lrwxrwxrwx  1   34  pci-0000:04:00.0.nffw -> flower/nic_AMDA0097-0001_2x40.nffw
    lrwxrwxrwx  1   34  pci-0000:06:00.0.nffw -> flower/nic_AMDA0096-0001_2x10.nffw

    /lib/firmware/netronome/flower:
    total 11692
    lrwxrwxrwx. 1      17  nic_AMDA0081-0001_1x40.nffw -> nic_AMDA0097.nffw
    lrwxrwxrwx. 1      17  nic_AMDA0081-0001_4x10.nffw -> nic_AMDA0097.nffw
    lrwxrwxrwx. 1      17  nic_AMDA0096-0001_2x10.nffw -> nic_AMDA0096.nffw
    -rw-r--r--. 1 3987240  nic_AMDA0096.nffw
    lrwxrwxrwx. 1      17  nic_AMDA0097-0001_2x40.nffw -> nic_AMDA0097.nffw
    lrwxrwxrwx. 1      17  nic_AMDA0097-0001_4x10_1x40.nffw -> nic_AMDA0097.nffw
    lrwxrwxrwx. 1      17  nic_AMDA0097-0001_8x10.nffw -> nic_AMDA0097.nffw
    -rw-r--r--. 1 3988184  nic_AMDA0097.nffw
    lrwxrwxrwx. 1      17  nic_AMDA0099-0001_2x10.nffw -> nic_AMDA0099.nffw
    lrwxrwxrwx. 1      17  nic_AMDA0099-0001_2x25.nffw -> nic_AMDA0099.nffw
    -rw-r--r--. 1 3990552  nic_AMDA0099.nffw

    /lib/firmware/netronome/nic:
    total 12220
    -rw-r--r--. 1 1380496  nic_AMDA0081-0001_1x40.nffw
    -rw-r--r--. 1 1389760  nic_AMDA0081-0001_4x10.nffw
    -rw-r--r--. 1 1385608  nic_AMDA0096-0001_2x10.nffw
    -rw-r--r--. 1 1385664  nic_AMDA0097-0001_2x40.nffw
    -rw-r--r--. 1 1391944  nic_AMDA0097-0001_4x10_1x40.nffw
    -rw-r--r--. 1 1397880  nic_AMDA0097-0001_8x10.nffw
    -rw-r--r--. 1 1386616  nic_AMDA0099-0001_1x10_1x25.nffw
    -rw-r--r--. 1 1385608  nic_AMDA0099-0001_2x10.nffw
    -rw-r--r--. 1 1386368  nic_AMDA0099-0001_2x25.nffw

If ``netronome/flower`` is not present, the *linux-firmware* package on the
system is probably outdated and does not contain the upstreamed OVS-TC
firmware. Refer to :ref:`0H_Upgrade_firmware:Appendix H: Upgrading TC Firmware`
for upgrade instructions. The NFP driver will search for firmware in
``/lib/firmware/netronome`` in the following order:

.. code-block:: text

    1: serial-_SERIAL_.nffw
    2: pci-_PCI_ADDRESS_.nffw
    3: nic-_ASSEMBLY-TYPE___BREAKOUTxMODE_.nffw

This search is logged by the kernel when the driver is loaded. For example::

    # dmesg | grep -A 4 nfp.*firmware
    [  3.260788] nfp 0000:04:00.0: nfp: Looking for firmware file in order of priority:
    [  3.260810] nfp 0000:04:00.0: nfp:   netronome/serial-00-15-4d-13-51-0c-10-ff.nffw: not found
    [  3.260820] nfp 0000:04:00.0: nfp:   netronome/pci-0000:04:00.0.nffw: not found
    [  3.262138] nfp 0000:04:00.0: nfp:   netronome/nic_AMDA0097-0001_2x40.nffw: found, loading...

The version of the loaded firmware for a particular *netdev* interface, as
found in :ref:`03_Driver_and_Firmware:SmartNIC Netdev Interfaces` (for example
``enp4s0``), or a physical port representor (for example, ``enp4s0np0``) can be
displayed with the ``ethtool`` command::

    # ethtool -i enp4s0np0
    driver: nfp
    version: 3.10.0-862.el7.x86_64 SMP mod_u
    firmware-version: 0.0.3.5 0.20 nic-2.0.7 nic
    expansion-rom-version:
    bus-info: 0000:04:00.0

Firmware versions are displayed in order: NFD version, NSP version, APP FW
version, driver APP. The specific output above shows that basic NIC firmware is
running on the card, as indicated by ``nic`` in the ``firmware-version`` field.

Selecting the TC Offload Firmware
=================================

In order to initialize the SmartNIC with the TC offload firmware, a symbolic
link based on the PCI address of the SmartNIC should be created to the desired
firmware. When the kernel module is loaded, it will load the specified firmware
instead of the default CoreNIC firmware. The TC offloaded firmware is located
in the ``netronome/flower`` directory in ``lib/firmware``.

Review :ref:`03_Driver_and_Firmware:SmartNIC Netdev Interfaces` to identify the
SmartNIC's *netdev*. The script in
:ref:`02_Hardware_installation:Identification` details how to identify the
SmartNIC's assembly.

The following script extract illustrates how to create and persist this
symbolic link:

.. code-block:: bash
    :linenos:

    #!/bin/bash
    DEVICE=${1}
    DEFAULT_ASSY=scan
    ASSY=${2:-${DEFAULT_ASSY}}
    APP=${3:-flower}

    if [ "x${DEVICE}" = "x" -o ! -e /sys/class/net/${DEVICE} ]; then
        echo Syntax: ${0} device [ASSY] [APP]
        echo
        echo This script associates the TC Offload firmware
        echo with a Netronome SmartNIC.
        echo
        echo device: is the network device associated with the SmartNIC
        echo ASSY: defaults to ${DEFAULT_ASSY}
        echo APP: defaults to flower. flower-next is supported if updated
        echo      firmware has been installed.
        exit 1
    fi

    # It is recommended that the assembly be determined by inspection
    # The following code determines the value via the debug interface
    if [ "${ASSY}x" = "scanx" ]; then
        ethtool -W ${DEVICE} 0
        DEBUG=$(ethtool -w ${DEVICE} data /dev/stdout | strings)
        SERIAL=$(echo "${DEBUG}" | grep "^SN:")
        ASSY=$(echo ${SERIAL} | grep -oE AMDA[0-9]{4})
    fi

    PCIADDR=$(basename $(readlink -e /sys/class/net/${DEVICE}/device))
    FWDIR="/lib/firmware/netronome"

    # AMDA0081 and AMDA0097 uses the same firmware
    if [ "${ASSY}" = "AMDA0081" ]; then
        if [ ! -e ${FWDIR}/${APP}/nic_AMDA0081.nffw ]; then
           ln -sf nic_AMDA0097.nffw ${FWDIR}/${APP}/nic_AMDA0081.nffw
       fi
    fi

    FW="${FWDIR}/pci-${PCIADDR}.nffw"
    ln -sf "${APP}/nic_${ASSY}.nffw" "${FW}"

    # insert distro-specific initramfs section here...

For RHEL 7.5+ and CentOS 7.5 systems, it is recommended to append the
following snippet:

.. code-block:: bash
    :linenos:
    :lineno-start: 42

    # RHEL 7.5+ and CentOS 7.5 distro-specific initramfs section
    DRACUT_CONF=/etc/dracut.conf.d/98-nfp-firmware.conf
    echo "install_items+=\" ${FW} \"" > "${DRACUT_CONF}"
    dracut -f

This adds the symlink and firmware to the initramfs. Alternatively, for Ubuntu
18.04 systems, append the following snippet, instead:

.. code-block:: bash
    :linenos:
    :lineno-start: 42

    # Ubuntu 18.04 distro-specific initramfs section
    HOOK=/etc/initramfs-tools/hooks/agilio_firmware
    cat >${HOOK} << EOF
    #!/bin/sh
    PREREQ=""
    prereqs()
    {
        echo "\$PREREQ"
    }
    case "\$1" in
    prereqs)
        prereqs
        exit 0
        ;;
    esac
    . /usr/share/initramfs-tools/hook-functions
    cp "${FW}" "\${DESTDIR}${FW}"
    if have_module nfp ; then
        manual_add_modules nfp
    fi
    exit 0
    EOF
    chmod a+x "${HOOK}"
    update-initramfs -u

As an example:

- The script has been assembled into ``./agilio-tc-fw-select.sh``
- A *netdev* associated with the SmartNIC is ``p5p1``
- The user wishes to auto-detect the Assembly ID

.. code-block:: console

    # ./agilio-tc-fw-select.sh p5p1 scan
    # rmmod nfp
    # modprobe nfp

If the out-of-tree firmware repository has been installed (as described in
:ref:`0H_Upgrade_firmware:Appendix H: Upgrading TC Firmware`) and the user
wishes to select that instead::

    # ./agilio-tc-fw-select.sh p5p1 scan flower-next
    # rmmod nfp
    # modprobe nfp

Verify Firmware is Loaded
-------------------------

The firmware should indicate that it has the FLOWER capability. This can be
confirmed by inspecting the kernel message buffer using ``dmesg``::

    # dmesg | grep nfp
    [ 3131.714215] nfp 0000:04:00.0 eth4: Netronome NFP-6xxx Netdev: TxQs=8/8 RxQs=8/8
    [ 3131.714221] nfp 0000:04:00.0 eth4: VER: 0.0.5.5, Maximum supported MTU: 9420
    [ 3131.714227] nfp 0000:04:00.0 eth4: CAP: 0x20140673 PROMISC RXCSUM TXCSUM RXVLAN GATHER TSO1 RSS2 AUTOMASK IRQMOD FLOWER

Loading of flower firmware may also be confirmed using ``ethtool``. ``AOTC``
indicates that OVS-TC firmware was loaded, as does ``flow``. e.g.::

    # ethtool -i ens3np0
    driver: nfp
    version: 3.10.0-862.el7.x86_64 SMP mod_u
    firmware-version: 0.0.5.5 0.22 0AOTC28A.5642 flow
    expansion-rom-version:
    bus-info: 0000:04:00.0

SmartNIC Netdev Interfaces
==========================

Representors
------------

Representor *netdevs*, or representors, are *netdevs* created to represent the
switch-side of a port. When Flower firmware for Agilio CX SmartNIC is loaded
the following *netdevs* are created:

- A *netdev* for the PCI physical function (PF) to represent the PCI connection
  between the host and the card.
- Representor *netdevs* for each physical port (MAC) of the card. These are
  used to allow configuration, for example of link state, of the port, to
  access statistics of the port and to carry fallback traffic. Fallback traffic
  are packets which are not handled by the datapath on the SmartNIC, usually
  because there is no matching rule present, and thus sent to the host for
  processing.
- A representor *netdev* for the PF. This is not currently used in an OVS-TC
  system.

When SR-IOV VFs (virtual functions) are instantiated, a representor *netdev* is
created for each VF. Like representors for physical ports, these are used for
configuration, statistics and fallback packets.  When using OVS-TC it is the
physical port representor *netdevs*, and VF representor *netdevs* that are
attached to OVS which then allow OVS to configure the associated ports and VFs
to send and receive fallback packets.

Identification
--------------

To identify the Agilio NIC interfaces, begin by identifying the physical
function and physical port representor names. This may be determined by
examining the *netdevs* of the PF PCI devices for the Agilio NIC. These PCI
devices may be determined using the ``lspci`` tool to list devices with
Netronome vendor:device tuples (``19ee:4000`` and ``19ee:6000``). The *netdevs*
associated with these devices may be determined by examining sysfs:

.. code-block:: bash
    :linenos:

    #!/bin/bash
    BDFS=$({ lspci -Dmmd 19ee:4000; lspci -Dmmd 19ee:6000; } | cut -f 1 -d " ")
    for i in $BDFS; do ls /sys/bus/pci/drivers/nfp/$i/net/; done

An example output of this would be:

.. code-block:: text

    enp4s0np0  enp4s0np1  p6p1

Where ``enp4s0np0`` and ``enp4s0np1`` are the physical port representors and
``p6p1`` is the physical function *netdev*:

The naming scheme for each port and physical function is dependent on the
motherboard and the PCI slot into which the NFP is installed. The PF name
should be that associated with the PCI slot and the physical port representor
names should be the PF name with ``np[x]`` appended.

.. note::

    Platform and BIOS configuration as well as enabling ``biosdevname`` can
    affect the port naming policies.

To confirm that the representor ``enp4s0np0`` is a physical port, verify the
contents of the following file in sysfs::

    # cat /sys/class/net/enp4s0np0/phys_port_name
    p0

The physical ports will report the physical port name, while the physical
function (in this case ``p6p1``) will report an error.

.. code-block:: console

    # cat /sys/class/net/p6p1/phys_port_name
    cat /sys/class/net/p6p1/phys_port_name: Operation not supported

Once a physical port name has been determined, it is possible to determine the
``phys_switch_id`` of the the NFP. This is required to determine the names of
the VF representors when multiple NFPs are installed in a host. If an NFP has
more than one physical port, both ports will share the same ``phys_switch_id``.
The PF will report an error when its ``phys_switch_id`` is queried. For
example, the ``phys_switch_id`` of the device for which ``enp4s0np0`` is a
physical port, is::

    # cat /sys/class/net/enp4s0np0/phys_switch_id
    00154d13510c

Please refer to the section :ref:`05_Using_linux_driver:Configuring SR-IOV`
for information on how to instantiate VFs.

To identify VF representors, query the devices listed in ``/sys/class/net`` for
``phys_port_name`` and ``phys_switch_id``. VFs will share the switch id and
report their individual VF number in the form ``p0vf[x]``.  To the following
script creates a translation variable in bash that translates from VF index to
interface name:

.. code-block:: bash
    :linenos:

    #!/bin/bash
    declare -A vf_repr_ifname
    for ifname in $(ls /sys/class/net); do
        pn=$(cat /sys/class/net/${ifname}/phys_port_name 2> /dev/null)
        [ "x${pn}" != "x" ] || continue
        vfidx=$(echo "${pn}" | sed -rn 's/pf0vf([0-9]+)$/\1/p')
        [ "x${vfidx}" != "x" ] || continue
        vf_repr_ifname[${vfidx}]="${ifname}"
    done

.. note::

    This operation is not atomic and so any other subsystem that renames the
    network devices may invalidate this table.

The virtual functions associated with a PF PCI address are symlinked into
the sysfs directory associated with the PF PCI device. For example, if the
PF is located at ``0000:04:00.0``, ``VF1`` would be at ``0000:04:08.1``, and
``VF9`` would be at ``000:04:09.1``. In ``/sys/bus/pci/devices/0000:04:00.0/``
``virtfn0`` and ``virtfn9`` would link to those addresses::

    # ls -og --time-style="+" /sys/bus/pci/drivers/nfp/0000:04:00.0/virtfn[19]
    lrwxrwxrwx 1 0  /sys/bus/pci/drivers/nfp/0000:04:00.0/virtfn1 -> ../0000:04:08.1
    lrwxrwxrwx 1 0  /sys/bus/pci/drivers/nfp/0000:04:00.0/virtfn9 -> ../0000:04:09.1

Support for ``biosdevname``
---------------------------

Netronome NICs support ``biosdevname`` *netdev* naming with recent versions
of the utility, circa December 2018, e.g. RHEL 8.0 and up. Furthermore,
``biosdevname`` will only be supported on kernel v4.19+. There are some
notable points to be aware of:

* Whenever an unsupported *netdev* is considered for naming, the
  ``biosdevname`` naming will be skipped and the next inline naming scheme
  will take preference, e.g. the ``systemd`` naming policies.

* *Netdevs* in breakout mode are not supported for naming.

* VF *netdevs* will still be subject to ``biosdevname`` naming irrespective
  of the breakout mode of other *netdevs*.

* Physical function *netdevs* are not supported for naming.

* PF and VF representor *netdevs* are not supported for naming.

* When using an older version of the ``biosdevname`` utility or an older
  kernel, users will observe inconsistent naming of *netdevs*.

To disable ``biosdevname`` users can add ``biosdevname=0`` to the kernel
command line.

Refer to the online ``biosdevname`` documentation for more details about the
naming policy convention that will be applied.

PF Link Configuration
=====================

The physical function *netdev* for the PCI device acts as a lower-device for
representors and must be up in order to allow sending and receiving fallback
traffic on representors. As the PF *netdev* is not used directly to carry
packets, it is recommended that it be brought up without an IP address.
It is also advised to set the maximum transmission unit for the PF interface to
the largest value supported by the firmware, as advertised in in the kernel
message buffer, to avoid fallback packets from being unnecessarily dropped due
to being larger than the MTU of the PF.

.. code-block:: console

    # dmesg | grep MTU
    [ 3131.714221] nfp 0000:04:00.0 eth4: VER: 0.0.5.5, Maximum supported MTU: 9420

Settings
--------

RHEL 7.5+ and CentOS 7.5+
~~~~~~~~~~~~~~~~~~~~~~~~~

*NetworkManager* may be configured to bring up a device without addresses as
follows. *NetworkManager* may not present on some installs (check with
``systemctl status NetworkManager.service``), it can be installed using
``yum``::

    # yum install NetworkManager

In this example, the device is ``p5p1`` (replace this to match the PF *netdev*
in question). First add the connection type to *NetworkManager*, then change IP
configurations as follows::

    # nmcli c add type ethernet ifname p5p1 con-name ethernet-p5p1
    Connection 'ethernet-p5p1' (0e3e4e76-f592-4814-963b-e3fbecf00504) successfully added.
    # nmcli c modify ethernet-p5p1 ipv4.method disabled
    # nmcli c modify ethernet-p5p1 ipv6.method ignore
    # nmcli c modify ethernet-p5p1 ethernet.mtu 9240
    # nmcli c modify ethernet-p5p1 connection.autoconnect yes

This process creates a connection for the *netdev*, disables the IPv4
configuration, sets the IPv6 configuration to be ignored and finally sets the
MTU of the PF to the maximum value supported by the firmware in order to avoid
drops of fallback packets.

*NetworkManager* may now be used to bring up the connection. This will bring
up the link on the physical function which is essential to allow communication
between the TC offload mechanism and the NFP.

.. code-block:: console

    # nmcli c up ethernet-p5p1

Ubuntu 18.04
~~~~~~~~~~~~

A *networkd-dispatcher* script can be used to set an interface's MTU and bring
up the link of the PF's *netdev* without adding any IP addresses to it.
Reconfiguring the MTU is discussed in more detail in
:ref:`05_Using_linux_driver:Configuring interface Maximum Transmission Unit
(MTU)`. In this example, a simple script is run for each routable interface.
Again, the device used here is ``p5p1`` which should be changed to match the
PF *netdev* installed in the system.

.. code-block:: bash
    :linenos:

    #!/bin/sh
    cat > /usr/lib/networkd-dispatcher/routable.d/50-ifup-noaddr << 'EOF'
    #!/bin/sh
    ip link set mtu 9420 dev p5p1
    ip link set up dev p5p1
    EOF
    chmod u+x /usr/lib/networkd-dispatcher/routable.d/50-ifup-noaddr

In order to ensure the hook above is run, regardless if
*networkd-dispatcher* runs before or after ``systemd-networkd``, the
configuration of *networkd-dispatcher* should be updated to generate events
reflecting the existing state and behavior when it starts up. This is the
``--run-startup-triggers`` option and may be passed to *networkd-dispatcher* on
start-up by adding it to ``/etc/default/networkd-dispatcher``.

.. code-block:: bash
    :linenos:

    #!/bin/sh
    cat > /etc/default/networkd-dispatcher << 'EOF'
    # Specify command line options here. This config file is used
    # by the included systemd service file.
    networkd_dispatcher_args="--run-startup-triggers"
    EOF

Restarting *network-dispatcher* should now set the MTU and bring up the link of
``p1p5`` if there are any routable interfaces.

.. note::

    For Ubuntu based systems, VF creation may also be done using this trigger
    method. Refer to :ref:`05_Using_linux_driver:Configuring SR-IOV` for
    details.

.. code-block:: console

    # systemctl restart networkd-dispatcher

The service status of *networkd-dispatcher* will then reflect the changes
implemented::

    # service networkd-dispatcher status
    ● networkd-dispatcher.service - Dispatcher daemon for systemd-networkd
          Loaded: loaded (/lib/systemd/system/networkd-dispatcher.service; enabled; vendor preset:
                        enabled)
          Active: active (running) since Wed 2018-05-16 13:05:48 UTC; 2min 31s ago
          Main PID: 41757 (networkd-dispat)
            Tasks: 2 (limit: 7372)
                  CGroup: /system.slice/networkd-dispatcher.service
                            └─41757 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers


Upping Physical Port Representors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When using ``libvirt`` to manage virtual machines on the host, it's also highly
recommended to up all physical port representors, whether or not they are
plugged into the physical network. This is because ``libvirt`` expects to
manage the virtual functions using *any* *netdev* associated with them. The
specific *netdev* chosen depends on which is listed first in *sysfs*. Since
it's very hard to control this, the recommended procedure is to apply the above
procedure to all the *netdevs* associated with the PF.

Verification
------------

Verify link state and MTU of the PF *netdev*. For example the *netdev*
``p5p1`` (unlike the physical port representors ``enp4s0np0`` or
``enp4s0np1``) outputs::

    # ip addr show p5p1
    14: p5p1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9420 qdisc mq state UP group default qlen 1000
        link/ether 0e:c4:88:90:27:88 brd ff:ff:ff:ff:ff:ff
        inet6 fe80::cc4:88ff:fe90:2788/64 scope link
          valid_lft forever preferred_lft forever
