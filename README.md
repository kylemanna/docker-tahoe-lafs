docker-tahoe-lafs
=================

Simple Tahoe LAFS storage node

## Approxmiate Quickstart for Ephermal Tahoe-LAFS grid

1. Start the docker introducer node, copy the introducer FURL (form: "pb://nodeid@172.17.0.220:3455,127.0.0.1:3455/secret")

    $ docker run --rm tahoe-lafs introducer

2. Create 10 storage nodes:

    $ tests/run-storage-nodes.sh -i pb://nodeid@172.17.0.220:3455,127.0.0.1:3455/secret

Caveats: Uses internal docker0 bridge to communicate.

## Setup a Grid using OpenVPN to bypass NAT

1. Setup a Tahoe-LAFS OpenVPN server.  I recommend looking at `kylemanna/openvpn` [Docker Trusted Build](https://registry.hub.docker.com/u/kylemanna/openvpn/).
2. Generate a certificate for each Tahoe-LAFS client.
3. Create an empty directory (used to store presistent data) and initialize Tahoe-LAFS:

        $ docker run -v $PWD:/tahoe --rm -it tahoe-dev tahoe create-node
        Node created in '/.tahoe'
         Please set [client]introducer.furl= in tahoe.cfg!
         The node cannot connect to a grid without it.
         Please set [node]nickname= in tahoe.cfg

4. Configure Tahoe-LAFS, i.e. `vim tahoe.cfg`.  At minimum setup the
   `introducer.furl` and `name`.
5. Install the OpenVPN client configuration file in this directory so it can be
   picked up the OpenVPN service that will run in the container, default name is
   `openvpn.conf`.  If using `kylemanna/openvpn`, this would be the output of the
   `ovpn_getclient` command.
6. Optionally, lock down permissions a bit tighter:

        $ sudo chown root:root *
        $ sudo chmod 400 openvpn.conf tahoe.cfg
        $ ls -l
        -r-------- 1 root root 8588 Jul  8 23:03 openvpn.conf
        drwx------ 2 root root 4096 Jul  8 22:59 private
        -r-------- 1 root root 1298 Jul  8 22:59 tahoe.cfg
        -rw-r--r-- 1 root root  291 Jul  8 22:59 tahoe-client.tac

7. Start up Tahoe-LAFS and OpenVPN (note: `--privileged` is necessary for OpenVPN to manager `tun` interfaces):

        $ docker run -v $PWD:/tahoe --rm -it --privileged tahoe-dev
