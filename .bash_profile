# .bash_profile

# http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html

# Case-insensitive globbing (used in pathname expansion)
#shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Delete words by ^W
#tty -s && stty werase ^- 2>/dev/null

# Save all lines of a multiple-line command in the same history entry
# (allows easy re-editing of multi-line commands)
shopt -s cmdhist

# Don't autocomplete when accidentally pressing tab on an empty line.
# (It takes forever and yields "Display all 15 gazillion possibilites?")
shopt -s no_empty_cmd_completion

# Use extended globbing
# shopt -s extglob

# Add private key identities to the authentication agent
ssh-add

for file in ~/.{export,alias,prompt,colors,install}
	do [ -r "$file" ] && source "$file"
done


# Enable some Bash 4 features when possible:
# `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar
	do shopt -s "$option" 2> /dev/null
done


# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && \
	complete -o "default" -o "nospace" -W \
		"$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | awk '{print $2}')" \
	scp sftp ssh


# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail \
	Safari iTunes SystemUIServer Terminal TextMate" killall


# Set git autocompletion and PS1 integration
if [ -f /etc/bash_completion.d/git ];
	then
		. /etc/bash_completion.d/git
fi
