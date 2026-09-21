#!/bin/sh
printf '\033c\033]0;%s\a' Briwats-first
base_path="$(dirname "$(realpath "$0")")"
"$base_path/HookUP.x86_64" "$@"
