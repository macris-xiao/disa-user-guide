Appendix A: Netronome Repositories
==================================

All the software mentioned in this document can be obtained via the official
Netronome repositories. Please find instructions below on how to enable access
to the aforementioned repositories from your respective linux distributions.

Importing gpg-key
-----------------

Download and Import GPG-key to your local machine:

For RHEL/Centos 7.5

.. code:: bash

    # Download the public key
    $ wget https://rpm.netronome.com/gpg/NetronomePublic.key

    # Import the public key
    $ rpm --import NetronomePublic.key

For Ubuntu 18.04 LTS

.. code:: bash

    # Download the public key
    $ wget https://deb.netronome.com/gpg/NetronomePublic.key

    # Import the public key
    $ apt-key add NetronomePublic.key

Configuring repositories
------------------------

For RHEL/Centos 7.5

.. code:: bash

    # add netronome's repository
    $ cat << 'EOF' > /etc/yum.repos.d/netronome.repo
    [netronome]
    name=netronome
    baseurl=https://rpm.netronome.com/repos/centos/
    EOF

    # update repository lists
    $ yum update


For Ubuntu 18.04 LTS

.. code:: bash

    # add netronome's repository
    $ mkdir -p /etc/apt/sources.list.d/
    $ echo "deb https://deb.netronome.com/apt stable main" > \
        /etc/apt/sources.list.d/netronome.list

    # update repository lists
    $ apt-get update
