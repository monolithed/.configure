#! /usr/bin/env sh

# Create a data URI from a file and copy it to the pasteboard
mime_type=$(file -b --mime-type "$1")

[[ ${mime_type} == text/* ]] && mime_type="${mime_type};charset=utf-8"

printf "data:${mime_type};base64,`openssl base64 -in "$1" | tr -d '\n'`" | \
	pbcopy | printf "=> data URI copied to pasteboard.\n"
