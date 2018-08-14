Install Open vSwitch
====================

Installation From a Recent Distribution
---------------------------------------

The preferred method of installing and upgrading Open vSwitch is through the
distribution repositories. The minimum recommended versions are those provided
in GA releases of distributions. As a guide they are as follows:

================ ===========================
Operating System Version
================ ===========================
RHEL/Centos 7.5  openvswitch-2.9.0-19.el7fdp
Ubuntu 18.04     2.9.0-0ubuntu1
================ ===========================

RHEL/Centos 7.5
```````````````

Please refer to Appendix B: Red Hat Repositories for information on configuring
Red Hat repositories. Once the repositories are configured install Open vSwitch
using yum:

.. code:: bash

    $ yum install openvswitch

Ubuntu 18.04 LTS
````````````````

.. code:: bash

    $ apt-get update
    $ apt-get install -y openvswitch-switch

To verify Open vSwitch installed correctly refer to Check OVS Install.

Installation from Source
------------------------

Installing Open vSwitch from source is only recommended for developers, the
official Open vSwitch Git repository contains instructions on how to build the
packages from the source for each supported operating system. The following
instructions are abridged versions of those installation commands.

Install Dependencies
````````````````````

RHEL 7.5 Dependencies
~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    $ yum install gcc make python-devel openssl-devel kernel-devel kernel-debug-devel
    $ yum install python-docutils python-jinja2 python-pygments python-setuptools rpm-build
    $ wget https://rpmfind.net/linux/fedora/linux/releases/25/Everything\
    /x86_64/os/Packages/p/python-pygments-2.1.3-2.fc25.noarch.rpm
    $ rpm -ivh python-pygments-2.1.3-2.fc25.noarch.rpm
    $ wget http://rpmfind.net/linux/centos/7.5.1804/os/x86_64/Packages/\
    python-sphinx-1.1.3-11.el7.noarch.rpm
    $ rpm -ivh python-sphinx-1.1.3-11.el7.noarch.rpm

Centos 7.5 Dependencies
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    yum install -y rpm-build git python-six desktop-file-utils openssl-devel \
    checkpolicy selinux-policy-devel autoconf automake libtool \
    python-sphinx groff graphviz python-twisted-core python-zope-interface \
    libcap-ng-devel

Ubuntu 18.04 Dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~

Add universe repository, which is not present by default:

.. code:: bash

    $ add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"

Install dependencies:

.. code:: bash

    $ apt-get install -y build-essential autoconf automake bzip2 debhelper \
    dh-python graphviz libcap-ng-dev libdpdk-dev libnuma-dev libssl-dev \
    libtool openssl procps python-all-dev python-setuptools python-six python-sphinx

Build and Install
`````````````````

To correctly build and run openvswitch from the source files it is recommended
to following installation instructions found in the official `Open vSwitch
repository <https://github.com/openvswitch/ovs/blob/master/Documentation/intro/install/general.rst>`_.
In general the installation is as follows:

RHEL 7.5 Build and Install
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    $ mkdir -p ~/rpmbuild/SOURCES
    $ cd ~/rpmbuild/SOURCES
    $ git clone https://github.com/openvswitch/ovs -b branch-2.9 --depth 1
    $ cd ovs
    $ ./boot.sh
    $ ./configure
    $ make dist
    $ mv *.tar.gz /root/rpmbuild/SOURCES
    $ cd ..
    $ tar -xzvf *.tar.gz
    $ cd openvswitch-*.*.*
    $ rpmbuild -bb $(pwd)/rhel/openvswitch-fedora.spec
    $ cd /root/rpmbuild/RPMS/x86_64
    $ ls -1 | xargs -n 1 yum -y localinstall

Centos 7.5 Build and Install
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    $ mkdir -p ~/rpmbuild/SOURCES
    $ cd ~/rpmbuild/SOURCES
    $ git clone https://github.com/openvswitch/ovs -b branch-2.9 --depth 1
    $ cd ovs
    $ ./boot.sh
    $ ./configure
    $ make dist
    $ mv *.tar.gz /root/rpmbuild/SOURCES
    $ cd ..
    $ tar -xzvf *.tar.gz
    $ cd openvswitch-*.*.*
    $ rpmbuild -bb $(pwd)/rhel/openvswitch.spec
    $ cd /root/rpmbuild/RPMS/x86_64
    $ ls -1 | xargs -n 1 yum -y localinstall

Ubuntu 18.04 Build and Install
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    $ git clone https://github.com/openvswitch/ovs.git -b branch-2.9 --depth 1
    $ cd ovs
    $ ./boot.sh
    $ ./configure
    $ make
    $ make install

Check OVS Install
`````````````````

If the installation procedure completed successfully, a ``systemctl status
openvswitch.service`` command should return the service’s status. More
information on using Open vSwitch is provided later in Using Open vSwitch.
