## Bootstrapping

This playbook targets Ansible 10 (Ansible Core 2.17), which is newer than what's available in Ubuntu 24.04. Use pipx to run the playbook with the correct version:

- `apt install pipx`
- clone this repo
- `pipx run --spec=ansible==10.2.0 ansible-playbook playbook.yaml`

pipx installs this version of Ansible globally in /usr/local/bin as part of the playbook, so you can use `ansible-playbook` directly after this bootstrapping step.
