# Tahoe-LAFS in a Docker Container

Simple Tahoe LAFS storage node with OpenVPN for NAT traversal.

Tested on [Vultr's $5/mo single CPU/512 MB RAM/160 GB storage node](http://bit.ly/1znzbJR).

## Setup a Grid using OpenVPN to bypass NAT

1. Setup a Tahoe-LAFS OpenVPN server.  I recommend looking at [kylemanna/openvpn](https://registry.hub.docker.com/u/kylemanna/openvpn/) trusted build.
2. Generate a certificate for each Tahoe-LAFS client.
3. Create an empty directory (used to store persistent data) and initialize Tahoe-LAFS:

        mkdir storage0 && cd storage0
        docker run -v $PWD:/tahoe --rm -it kylemanna/tahoe-lafs tahoe create-node

    Expected Output:

        Node created in '/.tahoe'
         Please set [client]introducer.furl= in tahoe.cfg!
         The node cannot connect to a grid without it.
         Please set [node]nickname= in tahoe.cfg

4. Configure Tahoe-LAFS.  At minimum set `introducer.furl` and `name`.  Refer to [Tahoe-LAFS documentation](https://tahoe-lafs.org/trac/tahoe-lafs/browser/docs/configuration.rst).

        vim tahoe.cfg

5. Install the OpenVPN client configuration file in this directory so it can be
   picked up the OpenVPN service that will run in the container, default name is
   `openvpn.conf`.  If using `kylemanna/openvpn`, this would be the output of the
   `ovpn_getclient` command.

6. *Optionally* lock down permissions a bit tighter:

        sudo chown root:root *
        sudo chmod 400 openvpn.conf tahoe.cfg

    Expected permissions:

        -r-------- 1 root root 8588 Jul  8 23:03 openvpn.conf
        drwx------ 2 root root 4096 Jul  8 22:59 private
        -r-------- 1 root root 1298 Jul  8 22:59 tahoe.cfg
        -rw-r--r-- 1 root root  291 Jul  8 22:59 tahoe-client.tac

7. Test Tahoe-LAFS and OpenVPN by running it in blocking + interactive mode, logs should appear:

        docker run -v $PWD:/tahoe --rm -it --cap-add=NET_ADMIN kylemanna/tahoe-lafs

8. *Optionally* install an upstart script to automatically start the container on Ubuntu by using [upstart.init](https://raw.githubusercontent.com/kylemanna/docker-tahoe-lafs/master/upstart.init), be sure to update the path to update the path for the volume share (`-v`) from above and stop the previously running container:

        curl https://raw.githubusercontent.com/kylemanna/docker-tahoe-lafs/master/upstart.init | sudo tee /etc/init/docker-tahoe.conf
        sudo vim /etc/init/docker-tahoe.conf
        start docker-tahoe


## Quickstart for Ephermal Tahoe-LAFS Grid

1. Start the docker introducer node, copy the introducer FURL (form: "pb://nodeid@172.17.0.220:3455,127.0.0.1:3455/secret")

        mkdir introducer0 && cd introducer0
        docker run -v $PWD:/tahoe --rm -it kylemanna/tahoe-lafs tahoe create-introducer
        INTRO=$(cat private/introducer.furl)

2. Create 10 storage nodes:

        tests/run-storage-nodes.sh -i $INTRO

Caveats: Uses internal docker0 bridge to communicate.

