rawr-box
========

Play-inspired team-based audio and job integration server.

Features:

* Plays WAVs/MP3s and Text-to-Speech over the PA via a web interface

* Ability to run async and scheduled background jobs via delayed_job

* Track commits via post-commit hooks and play fun sounds over the PA depending on commit activity

* Pull in Ticket information from Redmine for analysis and other fun programs

* Play a sound when a ticket is opened by the teams tester for any of the participants

UNREAL TOURNAMENT POST COMMIT HOOK
----------------------------------

Put this in your .git/hooks/post-commit file. Make sure the post-commit file has executable permissions. Make sure to customize your team handle and server name.

	#!/bin/sh
	TEAM_HANDLE='my_team_handle'
	BRANCH=`git branch | grep '*' | cut -d' ' -f 2`
	CHANGESET=`git rev-parse HEAD`
	URL="wget -O /dev/null http://my_server/commit/$TEAM_HANDLE?changeset=$CHANGESET&branch=$BRANCH"
	wget -O /dev/null $URL
