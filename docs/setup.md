# Setting up from scratch

We assume you have a fresh Ubuntu 24.04 LTS machine running. Note that we haven't yet tested this playbook on a cloud image, so you may run into conflicts with work done by cloud-init.

Our use of Ansible targets Ansible 10 (Ansible Core 2.17), which is newer than what's available in Ubuntu 24.04. The steps below install and use `pipx` to fetch and run the correct version of Ansible from PyPI.

## Update and reboot

```
apt upgrade --update
```

No better time to update the kernel than right now!

## Restoring from restic

If you're setting up a new host due to a hardware failure or to validate the playbook, start by restoring operational data from the restic repository. This restores Let's Encrypt wildcard certificates, data from live services, and archival data used to restore other services.

> [!IMPORTANT]
> Do these steps before running the main playbook unless you really mean to start from scratch!

1. Install restic:
   - `apt install pipx bzip2`
   - `pipx run --spec=ansible==10.2.0 ansible -m include_tasks -a file=etc/install-restic.yaml -e @etc/restic-vars.yaml localhost`
2. Visit https://robot.hetzner.com/storage and reset the password for the storage box named "Parker Skylake backups". Ensure the server and user name for the storage box matches `etc/storage-box.txt`.
3. Run `sudo ./scripts/backup_setup.sh`. This generates a new SSH key and adds the public SSH key to the storage box.
4. Restore snapshots:
   ```
   export RESTIC_REPOSITORY=sftp://$(cat etc/storage-box.txt):23/restic
   for dir in /srv/docker/management/traefik_data; do
      restic --insecure-no-password \
         --option=sftp.args='-i /root/.ssh/restic_ed25519 -o ServerAliveInterval=60 -o ServerAliveCountMax=240' \
         restore latest --path "$dir" --target /
   done
   ```

## Run the playbook

- `apt install pipx`
- `pipx run --spec=ansible==10.2.0 ansible-playbook playbook.yaml`

pipx installs this version of Ansible globally in /usr/local/bin as part of the playbook, so you can use `ansible-playbook` directly after this bootstrapping step.
