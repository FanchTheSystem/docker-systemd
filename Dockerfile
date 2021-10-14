ARG FROM_IMAGE=ubuntu
FROM ${FROM_IMAGE}

##
# debian and ubuntu use apt
# last centos and fedora use dnf & yum
# centos7 use only yum
##

RUN if [ $(command -v apt-get) ]; then apt-get -y -o Acquire::GzipIndexes=false update && apt-get upgrade -y && apt-get install -y python python3 sudo apt-utils bash ca-certificates gnupg gcc systemd systemd-sysv dbus rsyslog iproute2 net-tools traceroute iputils-ping dnsutils emacs-nox && apt-get clean; \
    elif [ $(command -v dnf) ]; then dnf upgrade -y && dnf --assumeyes install python2 python36 sudo dnf-utils bash gnupg gcc systemd systemd-sysv dbus rsyslog iproute net-tools traceroute iputils bind-utils emacs-nox && dnf clean all; \
    elif [ $(command -v yum) ]; then yum upgrade -y && yum install -y python python3 sudo yum-utils bash gnupg gcc systemd systemd-sysv dbus rsyslog systemd-networkd iproute net-tools traceroute iputils bind-utils emacs-nox && sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && yum clean all; \
    fi

ENV container docker

RUN cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ systemd-tmpfiles-setup.service = "$i"  ] || rm -f $i; done;

RUN rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;

# https://bugzilla.redhat.com/show_bug.cgi?id=1650342
# to have a network-online.target
#RUN if [ -e /etc/centos-release ]; then yum install -y systemd-networkd; fi
#RUN systemctl enable systemd-networkd

RUN systemctl enable rsyslog


VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]

STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]
