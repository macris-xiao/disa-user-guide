.. highlight:: console

Install Open vSwitch
====================

Installation From a Recent Distribution
---------------------------------------

The preferred method of installing and upgrading Open vSwitch is through the
distribution repositories. The minimum recommended versions are those provided
in supported releases of distributions. As a guide they are as follows:

================ ===============================
Operating System                 Version
================ ===============================
RHEL/CentOS 7.5  ``2.9.0-19.el7fdp``
RHEL 7.6         ``2.9.0-55.el7fdp``
Ubuntu 18.04 LTS ``2.9.0-0ubuntu1``
================ ===============================

RHEL 7.5+ and CentOS 7.5
````````````````````````

Please refer to :ref:`0B_RHEL_Repositories:Appendix B: Red Hat Repositories`
for information on configuring Red Hat repositories. Once the repositories are
configured, install Open vSwitch using ``yum``::

    # yum install openvswitch

Ubuntu 18.04 LTS
````````````````

In Ubuntu, Open vSwitch can be installed using ``apt-get``::

    # apt-get update
    # apt-get install openvswitch-switch


Check OVS Install
`````````````````

If the installation procedure completed successfully, ``systemctl status
openvswitch.service`` should return the service status. More information on
using Open vSwitch is provided later in :ref:`07_Using_openvswitch:Using Open
vSwitch`.

Installation from Source
------------------------

Installing Open vSwitch from source is only recommended for developers, the
official `Open vSwitch Git Repository <https://github.com/openvswitch/ovs>`_
contains instructions on how to build the packages from the source for each
supported operating system.
