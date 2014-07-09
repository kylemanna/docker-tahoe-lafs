# Debugging

Random notes, maybe useful to someone.

## View stdout/stderr from supervisord subprocceses:

    docker run -v $PWD:/tahoe --rm -it --privileged tahoe-dev supervisord -e DEBUG
