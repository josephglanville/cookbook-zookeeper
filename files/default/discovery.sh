#!/bin/bash
set -a
. /etc/env_vars
sdir="`dirname \"$0\"`"
ruby $sdir/discovery.rb "$@"
