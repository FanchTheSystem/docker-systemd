Docker Image with Systemd
=========================

### Should be used with Ansible Molecule:

#### In molecule.yml, add:

```yaml
platforms:
  - name: ${OS_NAME}-instance
    image: fanchthesystem/${OS_NAME}-with-systemd:latest
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    tmpfs:
      - /tmp
      - /run
```

### Or if you want to use it from command line:

```bash
docker run --name ${OS_NAME}-with-systemd -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro fanchthesystem/${OS_NAME}-with-systemd

docker exec -it ${OS_NAME}-with-systemd systemctl status

```

### Note:

OS_NAME can be 'ubuntu', 'centos' or 'debian'
