ARG FROM_IMAGE=ubuntu
FROM ${FROM_IMAGE}

RUN if [ $(command -v apt-get) ]; then apt-get -y -o Acquire::GzipIndexes=false  update && apt-get install -y python sudo bash ca-certificates gnupg gcc systemd systemd-sysv dbus && apt-get clean; \
    elif [ $(command -v dnf) ]; then dnf makecache && dnf --assumeyes install python sudo python-devel python*-dnf bash gnupg gcc systemd dbus && dnf clean all; \
    elif [ $(command -v yum) ]; then yum makecache fast && yum install -y python sudo yum-plugin-ovl bash gnupg gcc systemd dbus && sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && yum clean all; \
    elif [ $(command -v zypper) ]; then zypper refresh && zypper install -y python sudo bash python-xml gnupg gcc systemd dbus && zypper clean -a; \
    elif [ $(command -v apk) ]; then apk update && apk add --no-cache python sudo bash ca-certificates gnupg gcc systemd dbus; \
    elif [ $(command -v xbps-install) ]; then xbps-install -Syu && xbps-install -y python sudo bash ca-certificates gnupg gcc systemd dbus && xbps-remove -O; fi

ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]

STOPSIGNAL SIGRTMIN+3

CMD ["sh", "-c", "while true; do sleep 10000; done"]