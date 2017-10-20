#! /usr/bin/env sh

# http://uwsgi-docs.readthedocs.org/en/latest/Nginx.html

goodbye() {
	echo 'Goodbye!'
	exit 1;
}

echo 'Enter uWSGI location: ';
type -a uwsgi;

read location;

if [[ ! "$location" ]];
	then
		echo 'Do you need help? (y/n):';
		read help;

		if [ "$help" == y ];
			then
				locate uwsgi;

				echo 'Enter uWSGI location: ';
				read location;

				[[ "$location" ]] || goodbye;
		fi;
fi;


ln -s "$location" /usr/local/bin/uwsgi;


# /usr/local/etc/uwsgi/uwsgi.yaml

echo 'Enter uWSGI configuration location: ';
read config;

[[ "$config" ]] || goodbye;


echo 'Enter the project name from your configuration file: ';
read project;

[[ "$project" ]] || goodbye;


# /etc/init.d/uwsgi.py
echo 'Enter uWSGI-helper location: ';
read helper;

[[ "$helper" ]] || goodbye;

ln -s "$helper" /etc/init.d;

echo 'Add the alias into your .bashrc'
echo "alias uwsgi='sudo python /etc/init.d/uwsgi.py --path=$helper --name=$project'";
