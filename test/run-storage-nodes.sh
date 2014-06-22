#!/bin/bash
#
# Create a series of storage nodes with volatile storage for quick testing
# of docker image.  All data is lost when the nodes shut down.
#
#
# $0 -i <introducer furl>
#
set -ex

cnt=10

while getopts "i:c:" opt; do
    case $opt in
        c)
            cnt=$OPTARG
            ;;
        i)
            intro=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
    esac
done

declare -a cids

cids_exit() {
    echo "Exiting, cleaning up"
    docker kill "${cids[@]}"
    docker rm "${cids[@]}"
}

cids_stop() {
    echo "Signaling containers to stop"
    docker stop "${cids[@]}"
}

trap cids_stop SIGINT SIGTERM
trap cids_exit EXIT

for i in $(seq $cnt); do
    cid=$(docker run -d tahoe-lafs storage_node -i $intro)
    #cid=$(docker run -d ubuntu sleep 10)
    cids[${#cids[@]}]=$cid
done

docker wait "${cids[@]}"
