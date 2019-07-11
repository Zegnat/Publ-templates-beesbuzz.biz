#!/bin/bash

cd $(dirname "$0")
LOG=logs/pushl-$(date +%Y%m%d.log)

# redirect log output
if [ "$1" == "quiet" ] ; then
	exec >> $LOG 2>&1
else
	exec 2>&1 | tee -a $LOG
fi

# add timestamp
date

# run pushl
flock -n $HOME/var/pushl/run.lock $HOME/.local/bin/pipenv run pushl -rvvc $HOME/var/pushl \
    https://beesbuzz.biz/feed \
    http://publ.beesbuzz.biz/feed \
    https://tumblr.beesbuzz.biz/rss \
    -s http://beesbuzz.biz/feed

# while we're at it, clean out the log directory
find logs -type f -mtime +30 -print -delete