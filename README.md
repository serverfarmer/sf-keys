# sf-keys extension for Server Farmer

sf-keys is a very special extension - the only one, that is not cloned to managed servers directly from the original repository. Instead, you are supposed to fork it and replace all gpg/ssh keys with your own ones. Then, url of your forked repository should be placed into `get-url-keys-repository.sh` script in Server Farmer main repository.

##### Why all keys are stored in a separate repository?

When your farm will grow up, you will probably use multiple Server Farmer forked repositories, eg. main fork as the primary version (for most customers), and several separately fine-tuned versions to handle particular customers. All these forks can (and should) share the same sf-keys repository, which greatly reduces the error surface related to key management.


# Key types and roles

### security model

All ssh keys used by Server Farmer are stored in `/etc/local/.ssh` directory on *farm manager*, which is the main management server. **Security of this server is absolutely critical, as anyone who can access it, can do literally everything with your whole network, as well as with all networks, servers, domains etc. managed for your customers.**

To increase the overall security level, you can use master and slave farm managers, where master is the only one with management ssh private keys, while dedicated ssh private keys are copied to slave farm managers after generation.

### management key

Is ssh key used:
- in host setup phase, to attach new host to the farm and allow generating dedicated keys
- by main administrator (should be used only if dedicated keys are not available)

### dedicated key

Is ssh key used:
- for passwordless ssh root access from farm manager after the setup phase (this key is generated automatically during setup)
- for transferring backups from managed server to *backup collector* (this key is also generated automatically, for `backup` system user)
- for other administrators and any other people that should have access to particular managed server


# Files/directories overview

### gpg part

`gpg/` - this directory contains all your gpg public keys

`get-gpg-backup-key.sh` - this script prints the gpg filename without `.pub` extension (file with `.pub` extension should be present in `gpg/` directory)

`functions` - deprecated file, previously exposing `gpg_backup_key` shell function (now this is done by `get-gpg-backup-key.sh` script)


### ssh part

`ssh/` - this directory contains all your ssh management public keys (to be added to `/root/.ssh/authorized_keys` file on all hosts)

`get-ssh-dedicated-key.sh` - this script prints the full filename (including path) of dedicated ssh private key - in most cases, you shouldn't touch it

`get-ssh-device-key.sh` - this script prints the full filename of ssh private key used on MikroTik/Cisco network devices - default version of this script assumes, that all devices of given brand share one key, you can change this script if you want to use different key for each router

`get-ssh-management-key.sh` - **important script** - this script prints the the full filename (including path) of management ssh private key
- script takes one argument: hostname
- **this key should never be disclosed to anyone**, even other administrators
- if this script is executed on host without management key, it should instead print the full filename of dedicated ssh private key for given hostname - so other administrators are also able to use Server Farmer management tools, assuming that they have at least the dedicated key for particular host they want to manage

### custom logic

`setup.sh` - this script is re-executed each time Server Farmer setup is executed, and is responsible for:
- creating your standard groups and users, that should exist on all managed servers
- installing ssh management public keys on current host in `/root/.ssh/authorized_keys` file
- executing any custom logic you want to execute on all hosts in the farm
