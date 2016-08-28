# Automatic docker volume backup with git

This repository provides a sample setup to git commit a docker volume every time a file is updated.

The [fvanderbiest/volume-git-backup](https://hub.docker.com/r/fvanderbiest/volume-git-backup/) image on Docker Hub is built from the Dockerfile in the `sync` directory. Feel free to use it if it suits your needs. 

The [docker-compose](docker-compose.yml) file and [geoserver_mock/Dockerfile](geoserver_mock/Dockerfile) we provide here are only meant to ease testing. 

# fvanderbiest/volume-git-backup

This image is the one watching for updates on a given file and performing the commit (& optionally push) when change is detected. The volume to backup should be mounted on `/var/local/data`.

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


# geoserver_mock

This image is used for testing purposes: its goal is to periodically update content in a docker volume.
It kind of mimics what [GeoServer](http://geoserver.org/) does to its config directory.
