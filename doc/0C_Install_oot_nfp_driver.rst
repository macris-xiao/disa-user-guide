.. highlight:: console

Appendix C: Installing the Out-of-Tree NFP Driver
=================================================

The *nfp* driver can be installed via the Netronome repository, or built from
source, depending on your requirements.

.. note::

    The Out-of-Tree driver currently does not provide support for TC firmware
    on RHEL/CentOS.

Install Driver via Netronome Repository
---------------------------------------

Please refer to :ref:`0A_Netronome_Repositories:Appendix A: Netronome
Repositories` on how to configure the Netronome repository applicable to your
distribution. When the repository has been successfully added, install the
``nfp-driver`` package using the commands below.

Ubuntu 18.04 LTS
````````````````

.. code-block:: console

    # apt-cache search nfp-driver
    agilio-nfp-driver-dkms - agilio-nfp-driver driver in DKMS format.

    # apt-get install agilio-nfp-driver-dkms

Kernel Changes
``````````````

Take note that installing the ``dkms`` driver will only install it for the
currently running kernel. When you upgrade the installed kernel it may not
automatically update the the *nfp* module to use the version in the ``dkms``
package. In kernel versions older than v4.16 the ``MODULE_VERSION`` parameter
of the in-tree module was not set, which causes ``dkms`` to pick the module
with the highest ``srcversion`` hash (https://github.com/dell/dkms/issues/14).
This is worked around by the package install step by adding ``--force`` to the
``dkms`` install, but this will not trigger on a kernel upgrade. To work around
this issue, boot into the new kernel and then re-install the
``agilio-nfp-driver-dkms`` package.

This should not be a problem when upgrading from kernels v4.16 and newer as the
``MODULE_VERSION`` has been added and the ``dkms`` version check should work
properly. It's not possible to determine which ``nfp.ko`` file was loaded by
only relying on information provided by the kernel. However, it's possible to
confirm that the binary signature of a file on disk and the module loaded in
memory is the same.

To confirm that the module in memory is the same as the file on disk, compare
the ``srcversion`` tag. The in-memory module's tag is at
``/sys/module/nfp/srcversion``. The default on-disk version can be queried with
``modinfo``::

    # cat /sys/module/nfp/srcversion # In-memory module
    # modinfo nfp | grep "^srcversion:" # On-disk module

If these tags are in sync, the filename of the module provided by a ``modinfo``
query will identify the origin of the module::

    # modinfo nfp | grep "^filename:"

If these tags are not in sync, there are likely conflicting copies of the
module on the system: the initramfs may be out of sync or the module
dependencies may be inconsistent.

The in-tree kernel module is usually located at the following path (please
note, this module may be compressed with a ``.xz`` extension):

.. code-block:: text

    /lib/modules/$(uname -r)/kernel/drivers/net/ethernet/netronome/nfp/nfp.ko

The ``dkms`` module is usually located at the following path:

.. code-block:: text

    /lib/modules/$(uname -r)/updates/dkms/nfp.ko

To ensure that the out-of-tree driver is correctly loaded instead of the
in-tree module, the following commands can be run:

.. code-block:: bash
    :linenos:

    mkdir -p /etc/depmod.d
    echo "override nfp * extra" > /etc/depmod.d/netronome.conf
    depmod -a
    modprobe -r nfp; modprobe nfp
    update-initramfs -u

Building from Source
--------------------

Driver sources for Netronome Flow Processor devices, including the NFP-4000 and
NFP-6000 models can be found at: https://github.com/Netronome/nfp-drv-kmods

Ubuntu 18.04 Dependencies
`````````````````````````

.. code-block:: console

    # apt-get update
    # apt-get install -y linux-headers-$(uname -r) build-essential libelf-dev

Clone, Build and Install
````````````````````````

.. code-block:: bash
    :linenos:

    git clone https://github.com/Netronome/nfp-drv-kmods.git
    cd nfp-drv-kmods
    make
    make install
    depmod -a
