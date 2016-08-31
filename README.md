# Automatic docker volume backup with git

This repository is the source of the [fvanderbiest/volume-git-backup](https://hub.docker.com/r/fvanderbiest/volume-git-backup/) image on Docker Hub. 
The [fvanderbiest/volume-git-backup](https://hub.docker.com/r/fvanderbiest/volume-git-backup/) image provides an easy way to `git commit` a docker volume every time a file is updated. 
Feel free to use it if it suits your needs. Contributions welcomed.

This image expects to find the volume mounted in `rw` mode on `/var/local/data`.

The file to watch for changes should also be contained in this directory.
The `run.sh` script uses `inotifywait` to watch for updates on this file.

When change is detected, the script performs the commit and optionally pushes to a remote repository.

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

Required environment:
 * `WATCH_FILE`: file to watch (path relative to `/var/local/data`)
 * `GIT_COMMIT_MESSAGE`: string or expression evaluated in the volume to provide a commit message 
 * `GIT_USERNAME`: git username for commit
 * `GIT_EMAIL`: git email for commit

To push to a repository, these additional variables are required:
 * `REMOTE_NAME`: name of the git remote, eg `origin`
 * `REMOTE_URL`: git repository URL, eg `https://github.com/fvanderbiest/playground.git`
 * `TOKEN`: password or OAuth token (eg: [GitHub token](https://github.com/settings/tokens))

**WARNING**: the `git push` command performs a **forced update** to the `master` branch, which might result in **data loss** !

Optional:
 * `SLEEPING_TIME`: if `WATCH_FILE` does not exist at startup, time to wait before a new check starts. Defaults to 1 sec.


# testing

In the `tests` folder there's a [docker-compose](tests/docker-compose.yml) file to easily create a test environment. 

The Dockerfile in the `tests/geoserver_mock` directory creates an image whose purpose is to periodically update the contents of a docker volume.
It kind of mimics what [GeoServer](http://geoserver.org/) does to its config directory and is a lightweight alternative.
