#!/usr/bin/env bash

# czg-wrapper.sh: Wrapper script for czg to handle exit gracefully in lazygit
# Usage: bash ~/.config/czg/czg-wrapper.sh

set -e

# Run czg with config
czg --config=/Users/fuka/.config/czg/.czrc
