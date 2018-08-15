Validating the Driver
=======================

The Netronome SmartNIC physical function driver with support for OVS-TC offload
is included in Linux 4.13 and later kernels. The list of minimum required
operating system distributions and their respective kernels which include the
nfp driver are as follows:

================ ======================
Operating System Kernel package version
================ ======================
RHEL/Centos 7.5  3.10.0-862.el7
Ubuntu 18.04 LTS 4.15.0-20.21
================ ======================

Confirm Upstreamed NFP Driver
-----------------------------

To confirm that your current Operating System contains the upstreamed nfp
module:

.. code:: bash

    $ modinfo nfp | head -3
    filename:
    /lib/modules/<kernel package version>/kernel/drivers/net/ethernet/netronome/nfp/nfp.ko.xz
    description:    The Netronome Flow Processor (NFP) driver.
    license:        GPL

.. note::
    If the module is not found in your current kernel, refer to Appendix C:
    Installing the Out-of-Tree NFP Driver for instructions on installing the out-of-tree NFP driver,
    or simply upgrade your distributions and kernel version to include the upstreamed drivers.

Confirm that the NFP Driver is Loaded
-------------------------------------

Use lsmod to list the loaded driver modules and use grep to match the
expression for the NFP drivers:

.. code:: bash

    $ lsmod | grep nfp
    nfp                   161364  0

If the NFP driver isn’t loaded, try run the following command to manually load
the module:

.. code:: bash

    $ modprobe nfp

Validating the Firmware
=======================

Netronome SmartNICs are fully programmable devices and thus depend on the
driver to load firmware onto the device at runtime. It is important to note
that the functionality of the SmartNIC significantly depends on the firmware
loaded. The firmware files should be present in the following directory
(contents may vary depending on the installed firmware):

.. code:: bash

    $ ls -ogR --time-style="+" /lib/firmware/netronome/
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

If netronome/flower is not present, the linux-firmware package on the system is
probably outdated and does not contain the upstreamed OVS-TC firmware, refer to
Upgrading TC Firmware for upgrade instructions. The NFP driver will search for
firmware in /lib/firmware/netronome. Firmware is searched for in the following
order and the first firmware to be successfully found and loaded is used by the
driver::

    serial-<serial-no>.nffw
        pci-<pcidev>.nffw
            nic-<type>_<media>.nffw

This search is logged by the kernel when the driver is loaded. For example:

.. code:: bash

    $ dmesg | grep -A 4 nfp.*firmware
    [  3.260788] nfp 0000:04:00.0: nfp: Looking for firmware file in order of priority:
    [  3.260810] nfp 0000:04:00.0: nfp:   netronome/serial-00-15-4d-13-51-0c-10-ff.nffw: not found
    [  3.260820] nfp 0000:04:00.0: nfp:   netronome/pci-0000:04:00.0.nffw: not found
    [  3.262138] nfp 0000:04:00.0: nfp:   netronome/nic_AMDA0097-0001_2x40.nffw: found, loading...

The version of the loaded firmware for a particular <netdev> interface, as
found in
:ref:`03_Driver_and_Firmware:SmartNIC Netdev Interfaces`
(for example enp4s0), or an interface’s
port <netdev port> (eg enp4s0np0) can be displayed with the ethtool command

.. code:: bash

    $ ethtool -i <netdev/netdev port>
    driver: nfp
    version: 3.10.0-862.el7.x86_64 SMP mod_u
    firmware-version: 0.0.3.5 0.20 nic-792810 nic
    expansion-rom-version:
    bus-info: 0000:04:00.0

Firmware versions are displayed in order; NFD version, NSP version, APP FW
version, driver APP. The specific output above shows that basic NIC firmware is
running on the card, as indicated by "nic" in the firmware-version field.

Selecting the TC Offload Firmware
=================================

In order to initialise the SmartNIC with the TC offload firmware, a symbolic
link based on the PCI address of the SmartNIC must be directed to the desired
firmware. When the kernel module is loaded, it will load the specified firmware
instead of the default CoreNIC firmware. The TC offloaded firmware is located
in the netronome/flower directory in lib/firmware.

Creation and persistence of a symbolic link between the OVS-TC firmware to the
SmartNIC associated PCI address is automated with the subsequent script.
Review
:ref:`03_Driver_and_Firmware:SmartNIC Netdev Interfaces`
to identify the SmartNIC’s netdev. The script
in Hardware Installation: Identification details how to identify the SmartNIC’s
assembly, however, it is recommended to run the following script with the scan
parameter which queries the device’s assembly through the debug interface.

.. code:: bash

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

For RHEL 7.5 systems, it is recommended to append the following snippet:

.. code:: bash

    # RHEL 7.5 distro-specific initramfs section
    DRACUT_CONF=/etc/dracut.conf.d/98-nfp-firmware.conf
    echo "install_items+=\" ${FW} \"" > "${DRACUT_CONF}"
    dracut -f

For Ubuntu 18.04 systems, append the following snippet, instead:

.. code:: bash

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

- The script has been assembled into ./agilio-tc-fw-select.sh
- A netdev associated with the SmartNIC is p5p1
- The user wishes to auto-detect the Assembly ID

.. code:: bash

    ./agilio-tc-fw-select.sh p5p1 scan
    # rmmod nfp
    # modprobe nfp

If the out-of-tree firmware repository has been installed (as described in
Upgrading TC Firmware) and the user wishes to select that instead:

.. code:: bash

    # ./agilio-tc-fw-select.sh p5p1 scan flower-next
    # rmmod nfp
    # modprobe nfp

Verify Firmware is Loaded
-------------------------

The firmware should indicate that it has the FLOWER capability, this can be
confirmed by inspecting dmesg. e.g.:

.. code:: bash

    $ dmesg | grep nfp
    [ 3131.714215] nfp 0000:04:00.0 eth4: Netronome NFP-6xxx Netdev: TxQs=8/8 RxQs=8/8
    [ 3131.714221] nfp 0000:04:00.0 eth4: VER: 0.0.5.5, Maximum supported MTU: 9420
    [ 3131.714227] nfp 0000:04:00.0 eth4: CAP: 0x20140673 PROMISC RXCSUM TXCSUM RXVLAN GATHER TSO1 [ 3131.714227] nfp 0000:04:00.0 eth4: ... ... ...RSS2 AUTOMASK IRQMOD FLOWER

Loading of flower firmware may also be confirmed using ethtool. “AOTC”
indicates that OVS-TC firmware was loaded, as does “flow”. e.g.:

.. code:: bash

    $ ethtool -i <netdev>
    driver: nfp
    version: 3.10.0-862.el7.x86_64 SMP mod_u
    firmware-version: 0.0.5.5 0.22 0AOTC28A.5642 flow
    expansion-rom-version:
    bus-info: 0000:04:00.0

SmartNIC Netdev Interfaces
==========================

Representors
------------

Representor netdevs, or representors, are netdevs created to represent the
switch-side of a port. When Flower firmware for Agilio CX SmartNIC is loaded
the following netdevs are created:

- A netdev for the PCI physical function (PF) to represent the PCI connection
  between the host and the card
- Representor netdevs for each physical port (MAC) of the card. These are used
  to allow configuration, for example of link state, of the port, to access
  statistics of the port and to carry fallback traffic. Fallback traffic are
  packets which are not handled by the datapath on the SmartNIC, usually
  because there is no matching rule present, and thus sent to the host for
  processing.
- A representor netdev for the PF. This is not currently used in an OVS-TC
  system.

When SR-IOV VFs (virtual functions) are instantiated, a representor netdev is
created for each VF division of the PCIe lane. Like representors for physical
ports, these are used for configuration, statistics and fallback packets.
When using OVS-TC it is the physical port representor, referred to here as
<netdev port>, and VF representor netdevs that are attached to OVS which then
allow OVS to configure the associated ports and VFs to send and receive
fallback packets.

Identification
--------------

To identify the Agilio NIC Interfaces, begin by identifying the physical
function and physical port representor names. This may be determined by
examining the netdevs of the PF PCI devices for the Agilio NIC. These PCI
devices may be determined using the lspci tool to list devices with the
vendor:device tuples; 19ee:4000 and 19ee:6000. The netdevs associated with
these devices may be determined by examining sysfs. In the example below,
enp4s0np0 and enp4s0np1 are both physical port (<netdev port>) representors
whilst p6p1 is the physical function (<netdev>) netdev:

.. code:: bash

    $ BDFS=$({ lspci -Dnnd 19ee:4000; lspci -Dnnd 19ee:6000; } | cut -f 1 -d " ")
    $ for i in $BDFS; do ls /sys/bus/pci/drivers/nfp/$i/net/; done
    enp4s0np0  enp4s0np1  p6p1

The naming scheme for each port and physical function is dependent on the
motherboard and the pci slot into which the NFP is installed. The PF name
should be that associated with the PCI slot and the physical port names should
be the PF name with np<x> appended.

.. note::

    enabling biosdevname or bios configurations can affect the port naming policies.

For example, to confirm that the representor enp4s0np0 is a physical port,
should yield the output:

.. code:: bash

    $ cat /sys/class/net/<netdev port>/phys_port_name
    p0

The physical ports will report the physical port name, while the physical
function (in this case enp4s0) will report an error.

.. code:: bash

    $ cat /sys/class/net/<netdev>/phys_port_name
    cat /sys/class/net/enp4s0/phys_port_name: Operation not supported

Once a physical port name has been determined, it is possible to determine the
switch id of the the NFP.  This is required to determine the names of the VF
representors (VF reprs) when multiple NFPs are installed in a host.  If an NFP
has more than one physical port, both ports will share the same switch id.
Again, the PF will report an error when it’s switch id is queried. For example,
the switch id of the device for which enp4s0np0 is a physical port, is:

.. code:: bash

    $ cat /sys/class/net/enp4s0np0/phys_switch_id
    00154d13510c

Please refer to the section Configuring SR-IOV for information on how to
instantiate VFs.

To identify VF representors, query the devices listed in /sys/class/net for
phys_port_name and phys_switch_id.  VFs will share the switch id and report
their individual VF number in the form p0vf<x>.  To create a translation
variable in bash that translates from VF index to interface name, run the
following script:

.. code:: bash

    #!/bin/sh
    declare -A vf_repr_ifname
    for ifname in $(ls /sys/class/net) ; do
        pn=$(cat /sys/class/net/$ifname/phys_port_name 2> /dev/null)
        [ "x$pn" != "x" ] || continue
        vfidx=$(echo "$pn" | sed -rn 's/pf0vf([0-9]+)$/\1/p')
        [ "x$vfidx" != "x" ] || continue
        vf_repr_ifname[$vfidx]="$ifname"
    done

.. note::

    This operation is not atomic and so any other subsystem that renames the network devices may invalidate this table.

The virtual functions are identified by associated PCI addresses. The VF’s
address space begins at domain 8, function 0 of the PCI bus and increments per
VF. For example, VF1 presents address 0000:04:08.1, while VF9 will be at
000:04:09.1. The PCI address base to which VFs are offset from was identified
previously in Hardware Installation Furthermore, VFs are also symlinked as
virtfn<x> with x in the range of VFs in /sys/bus/pci/devices/<nfp-bus-info>,
for example:

.. code:: bash

    $ ls -og --time-style="+" /sys/bus/pci/drivers/nfp/0000:04:00.0/virtfn[19]
    lrwxrwxrwx 1 0  /sys/bus/pci/drivers/nfp/0000:04:00.0/virtfn1 -> ../0000:04:08.1
    lrwxrwxrwx 1 0  /sys/bus/pci/drivers/nfp/0000:04:00.0/virtfn9 -> ../0000:04:09.1

PF Link Configuration
=====================

The physical function <netdev> for the PCI device acts as a lower-device for
representors and must be up in order to allow sending and receiving fallback
traffic on representors. As the PF netdev is not used directly to carry packets
it is recommended that it be brought up without an IP address.
It is also advised to set the maximum transmission unit for the PF interface to
the largest value supported by the firmware, as advertised in dmesg below, to
avoid fallback packets from being unnecessarily dropped due to being larger
than the MTU of the PF.

.. code:: bash

    $ dmesg | grep MTU
    [ 3131.714221] nfp 0000:04:00.0 eth4: VER: 0.0.5.5, Maximum supported MTU: 9420

Settings
--------

RHEL/Centos 7.5
~~~~~~~~~~~~~~~

Network manager may be configured to bring up a device without addresses as
follows. Network manager may not present on some Centos distributions
(check with systemctl status NetworkManager.service), it can be installed using
yum:

.. code:: bash

    $ yum install NetworkManager

In the example the device is p5p1, this should be changed to match the PF
netdev in question. First add the connection type to network manager, then
change IP configurations as follows:

.. code:: bash

    # Create connection for netdev
    $ nmcli c add type ethernet ifname p5p1 con-name ethernet-p5p1
    Connection 'ethernet-p5p1' (0e3e4e76-f592-4814-963b-e3fbecf00504) successfully added.
    # Disable IPv4 configuration
    $ nmcli c modify ethernet-p5p1 ipv4.method disabled
    # Ignore IPv6 configuration
    $ nmcli c modify ethernet-p5p1 ipv6.method ignore
    # Set mtu to largest supported by firmware, as reported in dmsg, to avoid unnecessary
    # packet drops of large fallback packets
    $ nmcli c modify ethernet-p5p1 ethernet.mtu 9240

Network manager may now be used to bring up the connection. This will bring up
the link on the physical function which is essential to allow communication
between the TC offload mechanism and the NFP.

.. code:: bash

    $ nmcli c up ethernet-p5p1

Ubuntu 18.04
~~~~~~~~~~~~

A networkd-dispatcher script can be used to set an interface’s MTU and bring up
the link of the PF’s netdev without adding any IP addresses to it.
Reconfiguring the MTU is discussed in more detailed subsequently in Configuring
interface Maximum Transmission Unit (MTU). In this example a simple script is
run for each routable interface. Again, the device used here is p5p1 which
should be changed to match the specifc PF <netdev> installed in the system.

.. code:: bash

    $ cat > /usr/lib/networkd-dispatcher/routable.d/50-ifup-noaddr << 'EOF'
    #!/bin/sh
    ip link set mtu 9420 dev p1p5
    ip link set up dev p1p5
    EOF
    $ chmod u+x /usr/lib/networkd-dispatcher/routable.d/50-ifup-noaddr

In order to ensure the hook above is run, regardless of if networkd-dispatcher
runs before or after systemd-networkd, the configuration of networkd-dispatcher
should be updated to generate events reflecting the existing state and
behaviour when it starts up. This is the --run-startup-triggers option and may
be passed to networkd-dispatcher on start-up by adding it to
/etc/default/networkd-dispatcher.

.. code:: bash

    $ cat > /etc/default/networkd-dispatcher << 'EOF'
    # Specify command line options here. This config file is used
    # by the included systemd service file.
    networkd_dispatcher_args="--run-startup-triggers"
    EOF

Restarting network-dispatcher should now set the MTU and bring up the link of
p1p5 if there are any routable interfaces.

.. code:: bash

    $ systemctl restart networkd-dispatcher

The service status of networkd will then reflect the changes implemented

.. code:: bash

    $ service networkd-dispatcher status
    ● networkd-dispatcher.service - Dispatcher daemon for systemd-networkd
          Loaded: loaded (/lib/systemd/system/networkd-dispatcher.service; enabled; vendor preset:
                        enabled)
          Active: active (running) since Wed 2018-05-16 13:05:48 UTC; 2min 31s ago
          Main PID: 41757 (networkd-dispat)
            Tasks: 2 (limit: 7372)
                  CGroup: /system.slice/networkd-dispatcher.service
                            └─41757 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers

Verification
------------

Verify link state and MTU of the PF netdev. For example the netdev enp4s0
(not its ports enp4s0np0 or enp4s0np1) outputs:

.. code:: bash

    $ ip addr sh <netdev>
    14: enp4s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9420 qdisc mq state UP group default qlen 1000
        link/ether 0e:c4:88:90:27:88 brd ff:ff:ff:ff:ff:ff
        inet6 fe80::cc4:88ff:fe90:2788/64 scope link
          valid_lft forever preferred_lft forever

