# Automatic docker volume backup with git

[![License](https://img.shields.io/dub/l/vibe-d.svg)](LICENSE)
[![Pulls](https://img.shields.io/docker/pulls/fvanderbiest/volume-git-backup.svg)](https://hub.docker.com/r/fvanderbiest/volume-git-backup/)

This repository is the source of the [fvanderbiest/volume-git-backup](https://hub.docker.com/r/fvanderbiest/volume-git-backup/) image on Docker Hub.
The image provides an easy way to `git commit` a docker volume every time a file is updated.
Feel free to use it if it suits your needs. Contributions welcomed.

This image expects to find the volume mounted in `rw` mode on `/var/local/data`.

The file to watch for changes should also be contained in this directory.
Internally, we're using `inotifywait` to watch the file.

When change is detected, the script performs the commit and optionally pushes to a remote repository.

At startup, if a remote repository is configured a clone of this repository is
done in the volume. If volume is not empty, you will need to set FORCE_CLONE var
to 'yes' to force a cleanup of the volume. If the volume is already verionned
(contains a `.git` folder) then git remote is updated and local repository is updated
to the last commit of configured branch.

Example usage:
```yaml
sync:
  image: fvanderbiest/volume-git-backup
  environment:
    WATCH_FILE: global.xml
    GIT_COMMIT_MESSAGE: printf "updateSequence "; grep updateSequence global.xml|sed -e 's#.*ce>\(.*\)</up.*#\1#'
    GIT_USERNAME: fvanderbiest
    GIT_EMAIL: my.email@provider.com
  volumes:
    - geoserver_datadir:/var/local/data:rw
```
If `WATCH_FILE` environment is not set, volume will only be bootstraped from
remote git repository. Note that entrypoint will stop just after volume
bootstrap so you should configure container restart policy.

Required environment for watching:
 * `WATCH_FILE`: file to watch (path relative to volume root)
 * `GIT_COMMIT_MESSAGE`: string or expression evaluated in the volume to provide a commit message
 * `GIT_USERNAME`: git username for commit
 * `GIT_EMAIL`: git email for commit

To push to a repository, these additional variables are required:
 * `REMOTE_NAME`: name of the git remote, eg `origin`
 * `REMOTE_URL`: git repository URL, eg `https://github.com/fvanderbiest/playground.git`

Optional environment:
 * `REMOTE_BRANCH`: Remote branch to use. Defaults to master.
 * `FORCE_CLONE`: Delete volume content before cloning remote repository

To use SSH authentication to access remote repository, one of following
variables must be set:
 * `GIT_RSA_DEPLOY_KEY`: Private RSA key to use (eg: [GitHub deploy keys](https://developer.github.com/guides/managing-deploy-keys/))
 * `GIT_RSA_DEPLOY_KEY_FILE`: Path to a file containing the private RSA key to use


**WARNING**: the `git push` command performs a **forced update** to the `master` branch, which might result in **data loss** !

Optional:
 * `SLEEPING_TIME`: if `WATCH_FILE` does not exist at startup, time to wait before a new check starts. Defaults to 1 sec.


# testing

In the `tests` folder there's a [docker-compose](tests/docker-compose.yml) file to easily create a testing environment.

The Dockerfile in the `tests/geoserver_mock` directory creates an image whose purpose is to periodically update the contents of a docker volume.
It kind of mimics what [GeoServer](http://geoserver.org/) does to its config directory and is a lightweight alternative.
