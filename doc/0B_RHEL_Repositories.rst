.. highlight:: console

Appendix B: Red Hat Repositories
================================

TC offload is only available in Open vSwitch version 2.8, with additional
offloads enabled in 2.9. The standard Red Hat Subscription only enables
Open vSwitch version 2.5. For this reason, an additional subscription may be
required to enable repositories that contain a newer version of Open vSwitch.
Please consult with Red Hat directly to determine your subscription needs.

.. note::

    The Red Hat documentation with regards to enabling the specific
    repositories is regarded to be authoritative. The steps below are for
    illustrative purposes only.

Register the system with ``subscription-manager``::

    # subscription-manager register

List all available pools::

    # subscription-manager list --all --available

Identify the IDs of the license pools that provide the following products:

    - Red Hat Enterprise Linux
    - Red Hat Enterprise Linux Fast Datapath

This can be done by using the ``--matches`` flag::

    # subscription-manager list --available --matches="Red Hat Enterprise Linux Fast Datapath"

Attach the system to these pools (by using the correct license pool IDs)::

    # subscription-manager attach --pool=${RHEL_PACKAGE_POOL_ID}

Enable the Fast Datapath repository for the relevant version of RHEL:

RHEL 7.5+::

    # subscription-manager repos --enable rhel-7-fast-datapath-rpms

RHEL 8.0+::

    # subscription-manager repos --enable fast-datapath-for-rhel-8-x86_64-rpms
