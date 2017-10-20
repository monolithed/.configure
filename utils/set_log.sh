#! /usr/bin/env sh


LOG_DIR=/var/log;
PROJECT="example.com";

check_root() {
	if [ $UID -ne 0 ];
		then
			echo "Please run $0 as root." >&2;
			exit 1;
	fi
}

set_log() {
	if [[ ! -d "$LOG_DIR/$1" ]];
		then
			local LOG="$LOG_DIR/$1";

			mkdir -p $LOG;
			chmod +x+w $LOG;
			touch "$LOG/$PROJECT.$1.log";
	fi;
}

main () {
	check_root;

	set_log "django";
	set_log "uwsgi";
}

main;
