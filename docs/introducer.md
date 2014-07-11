
intro0$ docker run -v $PWD:/tahoe --rm -it kylemanna/tahoe-lafs tahoe create-introducer .
intro0$ ln -s tahoe-introducer.tac tahoe-client.tac
intro0$ cp /path/to/openvpn.conf openvpn.conf

