Appendix B: Red Hat Repositories
================================

TC offload is only available in openvswitch version 2.8, with additional
offloads enabled in 2.9.  The standard Red Hat Subscription only enables
openvswitch version 2.5.  For this reason an additional subscription may be
required to enable repositories that contain a newer version of openvswitch.
Please consult with Red Hat directly to determine your subscription needs.

.. note::

    The Red Hat documentation with regards to enabling the specific repos is regarded to be authoritative. The steps below are for illustrative purposes only.

Register the system with subscription-manager:

.. code:: bash

    $ subscription-manager register

List all available pools:

.. code:: bash

    $ subscription-manager list --all --available

Identify the IDs of the license pools that provide the following products:
- Red Hat Enterprise Linux
- Red Hat Enterprise Linux Fast Datapath
This can be done by using the --matches flag:

.. code:: bash

    $ subscription-manager list --available --matches="Red Hat Enterprise Linux Fast Datapath"

Attach the system to these pools (by using the correct licence pool IDs):

.. code:: bash

    $ subscription-manager attach --pool=<rhel package pool id>

Enable the Fast Datapath repository:

.. code:: bash

    $ subscription-manager repos --enable rhel-7-fast-datapath-rpms
