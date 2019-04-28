#!/bin/bash

# exit the script on command errors or unset variables
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# https://stackoverflow.com/a/246128/295807
readonly script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${script_dir}"

code .

if [[ "$(uname)" == "Darwin" ]]; then
    open_command=open
elif [[ "$(uname)" == "Linux" ]]; then
    open_command=xdg-open
fi

# Wait 2 seconds and open the browser
(sleep 2 && "${open_command}" "http://127.0.0.1:8000") &

# elm-reactor blocks and I want it in the fg
elm reactor
