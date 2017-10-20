#!/usr/bin/env sh

# @description:
# adduser command for Mac OS X Command Line
#
# @author       Alexander Guinness <monolithed@gmail.com>
# @version      0.0.1
# @license:     MIT, BSD, GPL
# @date:        Jun 15 02:46:00 2013


check_root() {
	if [ $UID -ne 0 ];
		then
			echo "Please run $0 as root." >&2;
			exit 1;
	fi
}

check_user() {
	if [ `dscl . -list /Users | grep $USERNAME` ];
		then
			echo "Error: user <$USERNAME> already exists."
			exit 1;
	fi
}

get_group() {
	if [ "$GROUP_ADD" == n ];
		then
			SECONDARY_GROUPS='staff';
	elif [ "$GROUP_ADD" == y ];
		then
			SECONDARY_GROUPS='admin _lpadmin _appserveradm _appserverusr';
	else
		echo 'You did not make a valid selection!';
	fi
}

set_group() {
	get_group;

	echo 'Adding user to specified groups...';

	for GROUP in $SECONDARY_GROUPS;
		do
			dseditgroup -o edit -t user -a $USERNAME $GROUP;
	done
}

add_user() {
	# Find out the next available user ID
	MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1);
	USERID=$((MAXID+1));

	echo 'Creating user directives...';

	dscl . -create /Users/$USERNAME;
	dscl . -create /Users/$USERNAME UserShell /bin/bash;
	dscl . -create /Users/$USERNAME RealName "$FULLNAME";
	dscl . -create /Users/$USERNAME UniqueID "$USERID";
	dscl . -create /Users/$USERNAME PrimaryGroupID 20;
	dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME;
	dscl . -create /Users/$USERNAME name "$USERNAME"
	dscl . -passwd /Users/$USERNAME $PASSWORD;

	dscl . -create /Groups/$USERNAME
	dscl . -create /Groups/$USERNAME PrimaryGroupID 20
	dscl . -append /Groups/$USERNAME RecordName jira

	set_group;
	add_dir;
}

add_dir() {
	# Create the home directory
	echo 'Creating home directory...';
	createhomedir -c 2>&1 | grep -v 'shell-init';

	echo "Created user #$USERID: $USERNAME > $FULLNAME";
	add_alias;
}

add_alias() {
	ln $0 -- /bin;
	alias adduser="sudo /bin/${0##*/}";
	echo "alias adduser=sudo /bin/${0##*/}" >> ~/.bashrc;
}


main() {
	# Create a UID that is not currently in use
	check_root;

	echo 'Enter user name: ';
	read USERNAME;

	check_user;

	echo 'Enter a full name for this user: ';
	read FULLNAME;

	echo 'Enter a password for this user: ';
	read -s PASSWORD;

	echo 'Is this an administrative user? (y/n):';
	read GROUP_ADD;

	add_user;
}

main;
