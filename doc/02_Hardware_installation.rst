.. highlight:: console

Hardware Installation
=====================

This user guide focuses on x86 deployments of Open vSwitch hardware
acceleration in supported versions of Ubuntu 18.04, Red Hat Enterprise Linux
and CentOS 7.5. As detailed in :ref:`03_Driver_and_Firmware:Validating the
Driver`, Netronome's Agilio SmartNIC firmware is now upstreamed with the latest
supported kernel versions of Ubuntu and RHEL/CentOS. Whilst out-of-tree driver
source files are available and installation instructions are included in
:ref:`0C_Install_oot_nfp_driver:Appendix C: Installing the Out-of-Tree NFP
Driver`, it is highly recommended, where possible, to make use of the
upstreamed drivers.  Wherever applicable, separate instructions for RHEL/CentOS
and Ubuntu are provided.

.. note:: All commands in this guide are assumed to be run as root

Identification
--------------

The serial number is printed beside a bar code on the outside of the card and
is of the form ``SMAAMDAXXXX-XXXXXXXXXXXX``. The ``AMDAXXXX`` section denotes
the assembly ID. In a running system, the assembly ID and serial number of a
PCI device may be determined by using the ``ethtool`` debug interface, if the
*netdev* associated with the SmartNIC is known, by passing it as the first
argument to the following script:

.. code-block:: bash
    :linenos:

    #!/bin/bash
    DEVICE=$1
    ethtool -W ${DEVICE} 0
    DEBUG=$(ethtool -w ${DEVICE} data /dev/stdout | strings)
    SERIAL=$(echo "${DEBUG}" | grep "^SN:")
    ASSY=$(echo ${SERIAL} | grep -oE AMDA[0-9]{4})
    echo ${SERIAL}
    echo Assembly: ${ASSY}

Consult :ref:`03_Driver_and_Firmware:SmartNIC Netdev Interfaces` for methods
identifying the *netdev*.

.. note::

    The ``strings`` command is commonly provided by the *binutils* package.
    This can be installed by ``yum install binutils`` or ``apt-get install
    binutils``, depending on your distribution.

Physical installation
---------------------

Physically install the SmartNIC in the host server and ensure proper cooling
e.g. airflow over card. Ensure the PCI slot is at least Gen3 x8 (can be placed
in Gen3 x16 slot). Once installed, power up the server and open a terminal.
Further details and support about the hardware installation process can be
reviewed in the Hardware User Manual available from Netronome's support site.

Validation
----------

Use the following command to validate that the SmartNIC is being correctly
detected by the host server and to identify its PCI address::

    # lspci -Dnnd 19ee:4000; lspci -Dnnd 19ee:6000
    0000:02:00.0 Ethernet controller [0200]: Netronome Systems, Inc. Device    [19ee:4000]

.. note::

    The ``lspci`` command is commonly provided by the *pciutils* package. This
    can be installed by ``yum install pciutils`` or ``apt-get install
    pciutils``, depending on your distribution.
