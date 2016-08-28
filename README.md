# Automatic docker volume backup with git

This is an sample setup to git commit a docker volume every time a file is updated.

# sync

This image is the one watching for updates on a given file and performing the commit when change is detected.

Example usage:
```yaml
sync:
  build: ./sync
  environment:
    WATCH_FILE: global.xml
    SLEEPING_TIME: 5
    COMMIT_MESSAGE: printf "updateSequence "; grep updateSequence global.xml|sed -e 's#.*ce>\(.*\)</up.*#\1#'
    REMOTE: origin
    REMOTE_URL: https://github.com/fvanderbiest/playground
    BRANCH: master
    USERNAME: fvanderbiest
    EMAIL: my.email@provider.com
    TOKEN: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  volumes:
    - geoserver_datadir:/var/local/data:rw
```

Variables:
 * `WATCH_FILE`: the file to watch
 * `SLEEPING_TIME`: if `WATCH_FILE` does not exist at startup, time to wait before a new checks starts
 * `COMMIT_MESSAGE`: string or expression evaluated in volume to provide a commit message 
 * `REMOTE`: name of the git remote
 * `REMOTE_URL`: where to find the git repository
 * `BRANCH`: branch to push commits to
 * `USERNAME`: well, it's your username
 * `EMAIL`: your email
 * `TOKEN`: your password, or probably better: a token (eg: [GitHub tokens](https://github.com/settings/tokens))

WARNING: the git commit command performs a **forced update**. If the branch already exists on the remote, it will be overwritten !


# geoserver_mock

This image is used for testing purposes: its goal is to periodically update content in a docker volume.
It kind of mimics what [GeoServer](http://geoserver.org/) does to its config directory.
