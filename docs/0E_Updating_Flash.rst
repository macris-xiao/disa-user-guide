.. highlight:: console

Appendix E: Updating NFP Flash
==============================

The NVRAM flash software on the SmartNIC can be updated in one of two ways,
either via ``ethtool`` or via the BSP userspace tools. In both cases, the BSP
package needs to be installed to gain access to the intended flash image. After
the flash has been updated, the system needs to be rebooted to take effect.

.. note::

    The ``ethtool`` interface is only available for hosts running kernel 4.16
    or higher when using the in-tree driver. Please use the out of tree driver
    to enable ``ethtool`` flashing on older kernels.

.. note::

    Updating the flash via ``ethtool`` is only supported if the existing flash
    version is greater than ``0028.0028.007c``.  Installed NVRAM flash version
    can be checked with the command ``dmesg | grep BSP``.  Cards running older
    versions of the NVRAM flash must be updated using the method in
    :ref:`0E_Updating_Flash:Update via BSP Userspace Tools`

Refer to :ref:`0D_Working_with_BSP:Appendix D: Working with Board Support
Package` to acquire the BSP tool package.

Update via Ethtool
------------------

To update the flash using ``ethtool``, the reflashing utilities used in the
Netronome directory in the system must first be relocated so that ``ethtool``
has access to them::

    # cp /opt/netronome/flash/flash-nic.bin /lib/firmware
    # cp /opt/netronome/flash/flash-one.bin /lib/firmware

Thereafter, ``ethtool`` can be used to reflash the software loaded onto the
SmartNIC devices identified by either their PF *netdev* or their physical
port representor::

    # ethtool -f ens3 flash-nic.bin
    # ethtool -f ens3 flash-one.bin

Update via BSP Userspace Tools
------------------------------

Obtain Out of Tree NFP Driver
`````````````````````````````

To update the flash using the BSP userspace tools, use the following steps.
Refer to :ref:`0C_Install_oot_nfp_driver:Appendix C: Installing the Out-of-Tree
NFP Driver` on installing the out of tree NFP driver and to load the driver
with CPP access.

Flash the Card
``````````````

The following commands may be executed for each card installed in the system
using the PCI address of the particular card. In this section, the card's PCI
address is assumed to be ``0000:04:00.0``. First reload the NFP drivers with
CPP access enabled::

    # rmmod nfp
    # modprobe nfp nfp_pf_netdev=0 nfp_dev_cpp=1

Then use the included Netronome flashing tools to reflash the card::

    # /opt/netronome/bin/nfp-flash --preserve-media-overrides \
        -w /opt/netronome/flash/flash-nic.bin -Z 0000:04:00.0
    # /opt/netronome/bin/nfp-one -Z 0000:04:00.0
    # reboot
