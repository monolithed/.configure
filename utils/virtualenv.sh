#! /usr/bin/env sh

# http://3bep.blogspot.ru/2010/11/virtualevn-virtualenvwrapper-and-pip.html


install() {
	if [[ -n `pip show $1` ]];
		then
			echo "Installing $1...\n" >&2;
			pip install $1;
	fi
}


add_user() {
	echo 'Enter user name: ';
	read USER;

	if [[ -z "$USER" ]];
		then
			dscl . -list /Users | grep $USERNAME || {
				adduser $USER;
				su $USER;
			}

			cd ~/$USER;

			echo 'Create new environment? (y/n): ';
			read ENV;

			[[  "$ENV" == y ]] && set_env;
		else
			exit 1;
	fi
}


add_project() {
	workon;

	echo 'Enter project name: ';
	read NAME;

	if [[ -z "$NAME" ]];
		then
			mkvirtualenv $NAME;
			cd $VIRTUAL_ENV;

			echo "The project $NAME is located in:";
			pwd;
	fi
}


set_env() {
	mkdir -p ~/env ~/workspace ~/vassals

	read -d '' env <<- EOF
		PYTHON=/opt/local/Library/Frameworks/Python.framework/Versions/3.3/bin

		export PYTHONPATH=/usr/bin/python:$PYTHONPATH
		export PATH=$PYTHON:$PATH

		export VIRTUALENVWRAPPER_PYTHON=$PYTHON/python3.3
		export WORKON_HOME=~/env;

		export PIP_VIRTUALENV_BASE=$WORKON_HOME
		export PIP_RESPECT_VIRTUALENV=true
	EOF

	2>&1 $env >> ~/.bashrc;

	mkdir -p $WORKON_HOME;

	source $PYTHON/virtualenvwrapper.sh;
	source ~/.bashrc

	mkvirtualenv $NAME;
	cd $VIRTUAL_ENV;

	echo 'Create new project? (y/n): ';
	read PROJECT;

	[[  "$PROJECT" == y ]] && add_project;
}


main() {
	if [ $UID -ne 0 ];
		then
			echo "Please run $0 as root." >&2;
			exit 1;
	fi

	install virtualenv;
	install virtualenvwrapper

	add_user;
}

main;
