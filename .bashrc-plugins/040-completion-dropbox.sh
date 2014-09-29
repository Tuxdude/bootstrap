#======================================================================================
#		  FILE:	dropbox
#
#		 USAGE:	Include in your bashrc or zshrc with "source dropbox". For system-wide
#		 		use, drop this file in the /etc/bash_completion.d directory. Then tab-
#		 		completion will work with the dropbox.py control script.
#
#  DESCRIPTION:	Bash/zsh completion script for dropbox.py
#
#		AUTHOR:	sluidfoe, sludfoe AT gmail DOT com
# LAST UPDATED:	2013-05-01
#======================================================================================

_dropbox()
{
	# Declare 'variables' local to this function
	local ifs lastchar dropbox_dir cur prev command exclude_com lansync_com
	# Path to the dropbox folder (this doesn't do anything right now)
	#dropbox_dir=~/Dropbox
	COMPREPLY=()
	# Word the cursor is currently in
	cur="${COMP_WORDS[COMP_CWORD]}"
	# Word prior to the cursor
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	# Commands for dropboxd
	command="autostart exclude filestatus help lansync ls puburl running start status stop"
	# Subcommands for autostart
	autostart_com="n y"
	# Subcommands for exclude
	exclude_com="add list remove"
	# Subcommands for lansync
	lansync_com="off on"

	# Completion of subcommands and arguments
	case "${prev}" in
		autostart)
			COMPREPLY=( $(compgen -W "${autostart_com}" -- "${cur}") )
			return 0
			;;
		exclude)
			COMPREPLY=( $(compgen -W "${exclude_com}" -- "${cur}") )
			return 0
			;;
		# The filestatus, ls, and puburl commands take files and directories as arguments
		# TODO: Complete only files and directories in $dropbox_dir?
		# TODO: These can take lists, so make sure that autocomplete works for that
		filestatus)
			;&
		ls)
			;&
		# As far as I can tell, the puburl command doesn't work. Anyone who can say otherwise, let me know
		puburl)
			COMPREPLY=( $(compgen -o plusdirs -f -- "${cur}") )
			if [ ${#COMPREPLY[@]} = 1 ] ; then
				[ -d "$COMPREPLY" ] && lastchar=/
				COMPREPLY=$(printf %q%s "$COMPREPLY" "$lastchar")
			else
				for ((i=0; i < ${#COMPREPLY[@]}; i++)); do
					[ -d "${COMPREPLY[$i]}" ] && COMPREPLY[$i]=${COMPREPLY[$i]}/ && compopt -o nospace
				done
			fi
			return 0
			;;
		# The help command takes any other command as an optional argument
		help)
			COMPREPLY=( $(compgen -W "${command}" -- "${cur}") )
			return 0
			;;
		lansync)
			COMPREPLY=( $(compgen -W "${lansync_com}" -- "${cur}") )
			return 0
			;;
		# The add and remove commands only accept directories, so that's what we complete
		add)
			;&
		remove)
			COMPREPLY=( $(compgen -d -- "${cur}") )
			for ((i=0; i < ${#COMPREPLY[@]}; i++)); do
				COMPREPLY[$i]=${COMPREPLY[$i]}/ && compopt -o nospace
			done
			;;
	esac

	# Completion of dropboxd commands
	if [[ $prev == dropbox ]] ; then
		COMPREPLY=( $(compgen -W "${command}" -- "${cur}") )
	fi
}
complete -F _dropbox dropbox
