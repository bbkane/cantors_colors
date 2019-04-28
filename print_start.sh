#!/bin/bash

# exit the script on command errors or unset variables
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# https://stackoverflow.com/a/246128/295807
# readonly script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# cd "${script_dir}"

make_print_color() {
    color_name="$1"
    color_code="$2"
    color_reset="$(tput sgr0)"
    if [ -t 1 ] ; then
        eval "print_${color_name}() { printf \"${color_code}%s${color_reset}\\n\" \"\$1\"; }"
    else  # Don't print colors on pipes
        eval "print_${color_name}() { printf \"%s\\n\" \"\$1\"; }"
    fi
}

make_print_color "red" "$(tput setaf 1)"
make_print_color "green" "$(tput setaf 2)"
make_print_color "yellow" "$(tput setaf 3)"

print_red "Always"
print_green "Seeing"
print_yellow "in Color!"
