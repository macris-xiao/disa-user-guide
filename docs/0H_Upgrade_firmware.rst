Appendix H: Upgrading TC Firmware
=================================

The preferred method of installing and upgrading Agilio firmware is via the
distribution repositories. The minimum recommended versions are those provided
in GA releases of distributions. As a guide they are as follows:

============ ===============================
Operating    System Firmware package version
============ ===============================
RHEL 7.5     20180220-62.git6d51311.el7
Ubuntu 18.04 1.173
============ ===============================

Netronome provides firmware packages with newer features as out-of-tree
repositories.  The corresponding installation packages can be obtained from
Netronome Support if access to the repositories is not available.
(https://help.netronome.com).

Installing Updated TC Firmware via the Netronome Repository
-----------------------------------------------------------

Please refer to :ref:`0A_Netronome_Repositories:Appendix A: Netronome
Repositories` on how to configure the Netronome repository applicable to your
distribution. When the repository has been successfully added install the
*agilio-flower-app-firmware* package using the commands below.

In RHEL/Centos 7.5:

.. code:: bash

    $ yum install agilio-flower-app-firmware --nogpgcheck

In Ubuntu 18.04 LTS

.. code:: bash

    $ apt-get install agilio-flower-app-firmware

Installing Updated TC Firmware from Package Installations
---------------------------------------------------------

The latest firmware can be obtained at the downloads area of the Netronome
Support site (https://help.netronome.com). Install the packages provided by
Netronome Support using the commands below.

In RHEL/Centos 7.5:

.. code:: bash

    $ yum install -y agilio-flower-app-firmware-*.rpm

In Ubuntu 18.04 LTS

.. code:: bash

    $ dpkg -i agilio-flower-app-firmware-*.deb

Select Updated TC Firmware
--------------------------

Once installed the updated TC firmware should be selected using the script
described in section :ref:`03_Driver_and_Firmware:Selecting the TC Offload
Firmware`. To select the updated TC firmware it should be called with
*flower-next* as its last parameter.

.. code:: bash

    $ ./agilio-tc-fw-select.sh p5p1 scan flower-next

Once selected the driver should be reloaded to use the new firmware.

.. code:: bash

    $ rmmod nfp; modprobe nfp

The initram image should also be update to ensure the correct firmware version
is loaded at boot time.

In RHEL/Centos 7.5 this is done using:

.. code:: bash

    $ dracut -f

In Ubuntu 18.04 LTS use the command:

.. code:: bash

    $ update-initramfs -u

