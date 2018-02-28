#!/bin/bash



export PORT=5102
export MIX_ENV=prod
export GIT_PATH=/home/webuser1/Tasktracker2/tasktracker2

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "webuser1" ]; then
	echo "Error: must run as user 'webuser1'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/tasktracker2 ]; then
	echo mv ~/www/tasktracker2 ~/old/$NOW
	mv ~/www/tasktracker2 ~/old/$NOW
fi

mkdir -p ~/www/tasktracker2
REL_TAR=~/Tasktracker2/tasktracker2/_build/prod/rel/tasktracker/releases/0.0.1/tasktracker.tar.gz
(cd ~/www/tasktracker2 && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/webuser1/Tasktracker2/tasktracker2/start.sh
CRONTAB

#. start.sh
