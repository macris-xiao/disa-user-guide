Appendix D: Working with Board Support Package
==============================================

The NFP BSP provides infrastructure software and a development environment for
managing NFP based platforms.

Install Software from Netronome Repository
------------------------------------------

Please refer to :ref:`0A_Netronome_Repositories:Appendix A: Netronome
Repositories` on how to configure the Netronome repository applicable to your
distribution. When the repository has been successfully added install the BSP
package using the commands below.

RHEL/Centos 7.5
```````````````

.. code:: bash

    $ yum list available | grep nfp-bsp
    nfp-bsp-6000-b0.x86_64                   2017.12.05.1404-1          netronome

    $ yum install nfp-bsp-6000-b0 --nogpgcheck
    $ reboot

Ubuntu 18.04 LTS
````````````````

.. code:: bash

    $ apt-cache search nfp-bsp
    nfp-bsp-6000-b0 - Netronome NFP BSP

    $ apt-get install nfp-bsp-6000-b0

Install Software From deb/rpm Package
-------------------------------------

Obtain Software
```````````````

The latest BSP packages can be obtained at the downloads area of the Netronome Support site (https://help.netronome.com).

Install the prerequisite dependencies
`````````````````````````````````````

RHEL/Centos 7.5 Dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

No dependency installation required

Ubuntu 18.04 LTS Dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    # BSP dependencies
    $ apt-get install -y libjansson4

NFP BSP Package
```````````````

Install the NFP BSP package provided by Netronome Support.

RHEL 7.5 Install
~~~~~~~~~~~~~~~~

.. code:: bash

    $ yum install -y nfp-bsp-6000-*.rpm --nogpgcheck

Ubuntu 18.04 LTS Install
~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    $ dpkg -i nfp-bsp-6000-*.deb

Using BSP tools
---------------

Enable CPP access
`````````````````

The NFP has an internal Command Push/Pull (CPP) bus that allows debug access to
the SmartNIC internals. CPP access allows user space tools raw access to chip
internals and is required to enable the use of most BSP tools. Only the
*out-of-tree (o-o-t)* driver allows CPP access.

Follow the steps from :ref:`0C_Install_oot_nfp_driver:Install Driver via
Netronome Repository` to install the o-o-t nfp driver. After the nfp module has
been built load the driver with CPP access:

.. code:: bash

    $ depmod -a
    $ rmmod nfp
    $ modprobe nfp nfp_dev_cpp=1 nfp_pf_netdev=0

To persist this option across reboots, a number of options are available; the
distribution specific documentation will detail that process more thoroughly.
Care must be taken that the settings are also applied to any initramfs images
generated.

Configure Media Settings
````````````````````````

Alternatively to the process described in
:ref:`05_Using_linux_driver:Configuring Interface Media Mode`, BSP tools
can be used to configure the port speed of the SmartNIC use the following
commands. Note, a reboot is still required for changes to take effect.

Agilio CX 2x25GbE - AMDA0099
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To set the port speed of the CX 2x25GbE the following commands can be used

.. code:: bash

    # set port 0 and port 1 to 10G mode
    $ nfp-media phy1=10G phy0=10G
    # set port 1 to 25G mode
    $ nfp-media phy1=25G+

To change the FEC settings of the 2x25GbE the following commands can be used

.. This still needs to be filled in

Agilio CX 1x40GbE - AMDA0081
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    # set port 0 to 40G mode
    $ nfp-media phy0=40G
    # set port 0 to 4x10G fanout mode
    $ nfp-media phy0=4x10G

Agilio CX 2x40GbE - AMDA0097
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    # set port 0 and port 1 to 40G mode
    $ nfp-media phy0=40G phy1=40G
    # set port 0 to 4x10G fanout mode
    $ nfp-media phy0=4x10G

    # for mixed configuration the highest port must be in 40G mode e.g.
    $ nfp-media phy0=4x10G phy1=40G


