Appendix F: Upgrading the Kernel
================================

RHEL 7.5
--------

It is only recommended to use kernel packages released by Red Hat and
installable as part of the distribution installation and upgrade procedure.

Centos 7.5
----------

The Centos package installer yum will manage an update to the supported kernel
version. The command ``$yum install kernel-<version>`` updates the kernel for
Centos. First search for available kernel packages then install the desired
release:

.. code:: bash

    $ yum list --showduplicates kernel
    kernel.x86_64
    3.10.0-862.el7
    base
    kernel.x86_64
    3.10.0-862.2.3.el7
    updates
    kernel.x86_64
    3.10.0-862.3.2.el7
    updates

    $ yum install kernel-3.10.0-862.el7

Ubuntu 18.04 LTS
----------------

If desired, alternative kernels may be installed. For example, at the time of
writing, v4.18 is the newest stable kernel.

Acquire packages
````````````````

.. code:: bash

    $ BASE=http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18/
    $ wget\
        $BASE/linux-headers-4.18.0-041800_4.18.0-041800.201808122131_all.deb \
        $BASE/linux-headers-4.18.0-041800-generic_4.18.0-041800.201808122131_amd64.deb \
        $BASE/linux-image-unsigned-4.18.0-041800-generic_4.18.0-041800.201808122131_amd64.deb \
        $BASE/linux-modules-4.18.0-041800-generic_4.18.0-041800.201808122131_amd64.deb

Install packages
````````````````

.. code:: bash

    $ dpkg -i \
        linux-headers-4.18.0-041800_4.18.0-041800.201808122131_all.deb \
        linux-headers-4.18.0-041800-generic_4.18.0-041800.201808122131_amd64.deb \
        linux-image-unsigned-4.18.0-041800-generic_4.18.0-041800.201808122131_amd64.deb \
        linux-modules-4.18.0-041800-generic_4.18.0-041800.201808122131_amd64.deb
