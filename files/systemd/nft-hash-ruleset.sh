#!/bin/bash
# This file is Puppet managed

umask 0377
/sbin/nft -s list ruleset | /usr/bin/sha1sum > $1
