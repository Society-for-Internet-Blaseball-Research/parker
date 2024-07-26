# Common operations tasks

## Editing and running the playbook

The playbook is set up to be run locally on the server. The correct version of Ansible is installed by the playbook itself.

Run `ansible-playbook` from the top of the repository (the directory containing `playbook.yaml`).

**Before you edit anything**, first run the playbook in check/diff mode to see if the state is what you expect:

```
ansible-playbook --check --diff playbook.yaml
```

Don't use `sudo`; Ansible will elevate privileges for you.

After you've edited the playbook and run in check/diff mode to verify your changes as best as Ansible will let you, run the playbook with:

```
ansible-playbook playbook.yaml
```

## Updating user SSH keys

User SSH keys are not managed by the Ansible playbook. After creating a new user or getting a request to add a key from the user, use `scripts/add_authorized_key.sh`:

```
./scripts/add_authorized_key.sh iliana "ssh-ed25519 AAAA..."
```

You can also provide a URL with a list of keys:

```
./scripts/add_authorized_key.sh iliana https://github.com/iliana.keys
```

## Cleaning up from uninstalled packages

Uninstalling a package with `apt` can leave ancillary files (configuration, logs, etc.) behind. `dpkg` keeps track of these packages. Run this to clean these packages up:

```
apt purge $(./scripts/unpurged_packages.sh)
```

Some "directory not empty so not removed" warnings will likely be emitted; be careful about blindly removing these, as many packages in Ubuntu "own" directories that don't strictly belong to them.
