Appendix A: Netronome Repositories
==================================

All the software mentioned in this document can be obtained via the official
Netronome repositories. Please find instructions below on how to enable access
to the aforementioned repositories from your respective Linux distributions.

Configuring Repositories
------------------------

For RHEL/CentOS 7.5:

.. code-block:: bash
    :linenos:

    cat << 'EOF' > /etc/yum.repos.d/netronome.repo
    [netronome]
    name=netronome
    baseurl=https://rpm.netronome.com/repos/centos/
    gpgcheck=0
    EOF
    yum makecache fast


For Ubuntu 18.04 LTS:

.. code-block:: bash
    :linenos:

    mkdir -p /etc/apt/sources.list.d/
    echo "deb [trusted=yes] https://deb.netronome.com/apt stable main" > \
        /etc/apt/sources.list.d/netronome.list
    apt-get update
