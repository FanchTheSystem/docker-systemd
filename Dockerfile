ARG FROM_IMAGE=ubuntu
FROM ${FROM_IMAGE}

RUN if [ $(command -v apt-get) ]; then apt-get -y -o Acquire::GzipIndexes=false  update && apt-get install -y python python3 sudo apt-utils bash ca-certificates gnupg gcc systemd systemd-sysv dbus rsyslog && apt-get upgrade -y && apt-get clean; \
    elif [ $(command -v dnf) ]; then dnf makecache && dnf --assumeyes install python2 python36 sudo dnf-utils bash gnupg gcc systemd systemd-sysv dbus rsyslog && dnf upgrade -y && dnf clean all &&  alternatives --auto python; \
    elif [ $(command -v yum) ]; then yum makecache fast && yum install -y python python3 sudo yum-utils bash gnupg gcc systemd systemd-sysv dbus rsyslog systemd-networkd && sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && yum upgrade -y && yum clean all; \
    fi

ENV container docker

RUN cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ systemd-tmpfiles-setup.service = "$i"  ] || rm -f $i; done;

RUN rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;

# to have a network-online.target
RUN systemctl enable systemd-networkd

RUN systemctl enable rsyslog


VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]

STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]
