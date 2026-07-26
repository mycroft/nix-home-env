#!/bin/sh

if test $# -ne 1
then
    echo "Usage: $0 <torrent file>"
    exit 1
fi

scp $1 rtorrent@maki.mkz.me:watch/
