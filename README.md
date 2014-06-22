docker-tahoe-lafs
=================

Simple Tahoe LAFS storage node

## Approxmiate Quickstart for ephermal Tahoe-LAFS grid

1. Start the docker introducer node, copy the introducer FURL (form: "pb://nodeid@172.17.0.220:3455,127.0.0.1:3455/secret")

    $ docker run --rm tahoe-lafs introducer

2. Create 10 storagenodes:

    $ tests/run-storage-nodes.sh -i pb://nodeid@172.17.0.220:3455,127.0.0.1:3455/secret

Caveats: Uses internal docker0 bridge to communicate.
