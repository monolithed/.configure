#! /usr/bin/env sh


PID_DIR=/var/run;
PROJECT="example.com";

check_root() {
	if [ $UID -ne 0 ];
		then
			echo "Please run $0 as root." >&2;
			exit 1;
	fi
}

set_pid() {
	if [[ ! -d "$PID_DIR/$1" ]];
		then
			local PID="$PID_DIR/$1";

			mkdir -p $PID;
			chmod +x+w $PID;
			touch "$PID/$PROJECT.$1.pid";
	fi;
}

main () {
	check_root;

	set_pid "uwsgi";
	#set_pid "nginx";
}

main;
