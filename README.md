# Automatic docker volume backup with git

This is an sample setup to git commit a docker volume every time a file is updated.

# sync

This image is the one watching for updates on a given file and performing the commit & push when change is detected. 
The volume to backup should be mounted on `/var/local/data`.

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
 * `WATCH_FILE`: the file to watch
 * `GIT_COMMIT_MESSAGE`: string or expression evaluated in volume to provide a commit message 
 * `GIT_USERNAME`: well, it's your username
 * `GIT_EMAIL`: your email

To push to a repository, these additional variables are required:
 * `REMOTE_NAME`: the name of the git remote, eg origin
 * `REMOTE_URL`: the git repository URL, eg https://github.com/fvanderbiest/playground.git
 * `TOKEN`: your password, or probably better: a token (eg: [GitHub tokens](https://github.com/settings/tokens))

**WARNING**: the `git push` command performs a **forced update** to the `master` branch, which might result in **data loss** !

Optional:
 * `SLEEPING_TIME`: if `WATCH_FILE` does not exist at startup, time to wait before a new checks starts. Defaults to 1 sec.


# geoserver_mock

This image is used for testing purposes: its goal is to periodically update content in a docker volume.
It kind of mimics what [GeoServer](http://geoserver.org/) does to its config directory.
