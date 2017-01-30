#!/usr/bin/env bash

# Copyright 2017 Confluent Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

: <<'DESCRIPTION'
Confluent Inc, index cleanup script for KAFKA-4497

https://issues.apache.org/jira/browse/KAFKA-4497 

Due to the bug described in the link above it is possible for timeindex files to be corrupted. 

Although a fix for this issue is included in 0.10.1.1+ it does not handle the case where index files are already corrupt. 
Instead it prevents the generation of corrupted index files alltogether. 
In order to fully recover from this sitatuon the broker must be forced to regenerate it's index files. 

This script intends to do so in a safe and convenient manner.        
DESCRIPTION

USAGE="Confluent Inc, index cleanup script for KAFKA-4497\n
Execute on one Broker at a time, supplying the correct\n
directory to index files. The script will check to ensure\n
no log files containing data are accessible and will remove\n
the corrupted index files.\n

\nusage: usage: $0 log.dirs\nNote: log.dirs should be space delimted"

CORRUPT=(.index .timeindex .timeindex.cleaned)

# dryRun: ensure no .log files exist on find result set
function dryRun() {
        echo "dryrun: finding $1 in $DIR"
        find $DIR -type f -name *$1 -exec echo "{}" \; | grep ".log$"
        if [ "$?" -eq "0" ]; then
                echo ".log files found in search, aborting operation to avoid data loss"
                exit 1
        fi
}

# remove: remove index files from designated directories 
function remove() {
        echo "removing $1 from $DIR"
        find $DIR -type f -name *$1 -exec rm {} \;
}

# ensure: ensure that all of the arguments are valid directories 
function ensure() {
        if [ ! -d "${1:+$1/}" ]; then
                echo "Directory $1 does not exist, aborting operation"
                exit 1
        fi
}

# iterate: perform function $1 on the rest of the arguments provided
function iterate() {
        for f in ${@:2}; do
                $1 $f
        done
}

# main: execute clean up process
function main() {
        iterate ensure $DIR
        iterate dryRun ${CORRUPT[*]}
        iterate remove ${CORRUPT[*]}
        exit 0

        echo "Directory $1 does not exist exiting"
        exit 1
}

# entry point to the script 
if [ "$#" -lt "1" ]; then
        echo $USAGE
        exit 1
fi

DIR=$@
main
