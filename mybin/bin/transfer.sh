#!/bin/bash
scp Downloads/*.torrent didon:/data/torrent/watch

if [[ $? -eq 0 ]]; then
    echo "Successfully transferred torrent to didon"
    rm Downloads/*.torrent
    rm -f Downloads/FlashPlayer*.dmg
else
    echo "Failed to transfer torrent to didon"
    exit 1
fi

