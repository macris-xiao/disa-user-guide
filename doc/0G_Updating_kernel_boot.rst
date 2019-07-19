Appendix G: Updating Kernel Boot Parameters
===========================================

.. note::

    In order to enable VFs to be bound to the ``vfio-pci`` driver such
    that they may be utilized by VMs, IOMMU must be enabled in both the BIOS
    of the host machines, as well as the kernel.

RHEL 7.5+ and CentOS 7.5+ Grub Config
-------------------------------------

.. code-block:: console

    # grubby --update-kernel=ALL --args="intel_iommu=on"
    # reboot

Ubuntu 18.04 LTS Grub Config
----------------------------

.. code-block:: console

    # sed -i 's/#*GRUB_CMDLINE_LINUX_DEFAULT.*/GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on"/g' /etc/default/grub
    # update-grub2
    # reboot
