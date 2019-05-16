Docker Image with Systemd
=========================

### Should be used with Ansible Molecule:

#### In molecule.yml, add:

```yaml
platforms:
  - name: ${OS_NAME}-instance
    image: fanchthesystem/${OS_NAME}-with-systemd:latest
    command: /sbin/init
    capabilities:
      - SYS_ADMIN
    privileged: True
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    tmpfs:
      - /tmp
      - /run
```

### Or if you want to use it from command line:

```bash
docker run -it -v /sys/fs/cgroup:/sys/fs/cgroup:ro fanchthesystem/docker-${OS_NAME}-with-systemd /bin/bash
```

### Note:

OS_NAME can be 'ubuntu', 'centos' or 'debian'
