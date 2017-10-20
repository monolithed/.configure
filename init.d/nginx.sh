#! /usr/bin/env sh

# @description: Nginx is an HTTP(S) server, HTTP(S)
# reverse proxy and IMAP/POP3 proxy server
#
# @synopsis:    nginx.sh [ start| stop | restart | reload | process | info ]
# @author       Alexander Guinness <monolithed@gmail.com>
# @version      0.0.1
# @license:     MIT, BSD, GPL
# @date:        Jun 12 01:33:00 2013

read -d '' NGINX_HELP <<- EOF
	Usage:
		${0} [ start | stop | quit | restart | reload | reopen | test | info | help ]

	Call pure nginx process:
	${0} precess [-?hvVtq] [-s signal] [-c filename] [-p prefix] [-g directives]

	Options:
		-?,-h         : This help

		-v            : Show version and exit

		-V            : Show version and configure options then exit

		-t            : Test configuration and exit.
		                Nginx checks configuration for correct syntax
		                and then try to open files referred in configuration.

		-q            : Suppress non-error messages during configuration testing

		-s signal     : Send signal to a master process: stop, quit, reopen, reload

		-p prefix     : Set prefix path (default: /opt/local/)

		-c filename   : Set configuration file (default: /opt/local/etc/nginx/nginx.conf)

		-g directives : Set global directives out of configuration file (version >=0.7.4)

		For more info see http://wiki.nginx.org/CommandLine
EOF

# NOTE: By default the PID stored in /usr/local/nginx/logs/nginx.pid

NGINX_PATH="/opt/local";
NGINX_FILE="${NGINX_PATH}/sbin/nginx";
NGINX_CONF="${NGINX_FILE} -c ${NGINX_PATH}/etc/nginx/nginx.conf";


function __launch {
	test && 2>&1 ${NGINX_FILE} -s $1
}

function __kill {
	local text="nginx has been stopped"

	pgrep nginx &>/dev/null && __launch $1 && \
		echo "${text}" || \
		echo "${text} already"
}

function test {
	[[ $1 -ne 1 ]] && \
		2>&1 ${NGINX_CONF} -t &>/dev/null || ${NGINX_CONF} -t
}

function start {
	test && ${NGINX_CONF} 2>&1 && \
		echo 'nginx has been started'
}

function stop {
	__kill stop
}

function quit {
	__kill quit
}

function reload {
	__launch reload 2>&1
}

function reopen {
	__launch reopen 2>&1
}

function restart {
	stop; start
}

function info {
	ps axw -o pid,user,%cpu,%mem,command | {
		awk 'NR == 1 || /uwsgi/' | grep -v awk;
		echo -$_{1..80} | tr -d ' ';
	}

	2>&1 ${NGINX_FILE} -V | sed 's/--/\'$'\n&/g'
}

function help {
	echo "${NGINX_HELP}";
}

if [[ ! -x "${NGINX_FILE}" ]]
	then
		echo "[error] '${NGINX_FILE}' not found"
		exit 2
fi

case "${1}" in
	start|stop|quit|restart|reload|reopen|info|help)
		${1}
	;;

	test)
		test 1
	;;

	*)
		${NGINX_FILE} $@
	;;
esac
