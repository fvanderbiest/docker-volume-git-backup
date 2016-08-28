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
    SLEEPING_TIME: 5
    COMMIT_MESSAGE: printf "updateSequence "; grep updateSequence global.xml|sed -e 's#.*ce>\(.*\)</up.*#\1#'
    USERNAME: fvanderbiest
    EMAIL: my.email@provider.com
    PUSH: 'true'
    REMOTE_URL: https://github.com/fvanderbiest/playground
    REMOTE_NAME: origin
    TOKEN: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  volumes:
    - geoserver_datadir:/var/local/data:rw
```

Variables:
 * `WATCH_FILE`: the file to watch
 * `SLEEPING_TIME`: (optional) if `WATCH_FILE` does not exist at startup, time to wait before a new checks starts. Defaults to 1 sec.
 * `COMMIT_MESSAGE`: string or expression evaluated in volume to provide a commit message 
 * `USERNAME`: well, it's your username
 * `EMAIL`: your email
 * `PUSH`: boolean, defaults to `'false'`. If `'true'`, git push master branch to repository.
 
Required only if `PUSH` is set to `'true'`:
 * `REMOTE_NAME`: name of the git remote
 * `REMOTE_URL`: where to find the git repository
 * `TOKEN`: your password, or probably better: a token (eg: [GitHub tokens](https://github.com/settings/tokens))

WARNING: the `git push` command performs a **forced update** to the `master` branch, which might result in **data loss** !


# geoserver_mock

This image is used for testing purposes: its goal is to periodically update content in a docker volume.
It kind of mimics what [GeoServer](http://geoserver.org/) does to its config directory.
