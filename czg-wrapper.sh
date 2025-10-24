#!/usr/bin/env bash

# czg-wrapper.sh: Wrapper script for czg to handle exit gracefully in lazygit
# Usage: bash ~/.config/czg/czg-wrapper.sh

set -e

# Colors
BLUE='\033[0;34m'
NC='\033[0m'

# Run czg with config
czg --config=/Users/fuka/.config/czg/.czrc

# Check exit status
exit_status=$?

# If czg was interrupted or failed, wait for user input
if [ $exit_status -ne 0 ]; then
    echo ""
    echo -n "Enterキーでlazygitに戻る..."
    read -r
fi

exit $exit_status
