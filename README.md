[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

# Borg Backup

A Docker image providing [Borg](https://www.borgbackup.org/) in a handy format.

## Installation

This Docker image contains a little helper / wrapper script which you install into a directory of your choice. Once
it is in place, you can call the script almost as if you are calling the `borg` binary directly.

````bash
docker run --name borg --rm flownative/borgbackup get-borg > /usr/local/bin/borg
chmod 775 /usr/local/bin/borg
````

Given that `/usr/local/bin` is in your `PATH`, you can get a help screen like so:

````bash
$ borg

usage: borg [-V] [-h] [--critical] [--error] [--warning] [--info] [--debug]
            [--debug-topic TOPIC] [-p] [--log-json] [--lock-wait SECONDS]
            [--show-version] [--show-rc] [--umask M] [--remote-path PATH]
            [--remote-ratelimit RATE] [--consider-part-files]
            [--debug-profile FILE] [--rsh RSH]
            <command> ...

Borg - Deduplicated Backups

optional arguments:
  -V, --version         show version number and exit

Common options:
  -h, --help            show this help message and exit
…
````
## Initializing a Backup

tbd.

## Creating Backups

Create a new archive (ie. "a new backup") using the arguments explained in the Borg documentation. The source directory
containing the files to backup is mounted as /source by default. You may, however, specify a custom mount point, so
paths in your archive are more meaningful.

Given that the following environment variables are set ...

````bash
export BORG_SSH_KEY_FILE=/home/fltwht/.ssh/id_rsa
export BORG_REPO=...repo.borgbase.com:repo
export BORG_SUDO=yes
export BORG_PASSPHRASE=...
export BORG_SOURCE_ROOT_DIR=/media/data/nextcloud/data
export BORG_SOURCE_MOUNT_DIR=/nextcloud/data
````
... you can create new archive like so:

```bash
./borg create                                              \
      --verbose                                            \
      --list                                               \
      --stats                                              \
      --show-rc                                            \
      --compression lz4                                    \
      --exclude ${BORG_SOURCE_MOUNT_DIR}/video             \
      --exclude ${BORG_SOURCE_MOUNT_DIR}/*/files_trashbin  \
      --exclude ${BORG_SOURCE_MOUNT_DIR}/appdata_*/preview \
                                                           \
      ::'nextcloud-{now}'                                  \
      ${BORG_SOURCE_MOUNT_DIR}
```
