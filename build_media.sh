#! /bin/bash
# Usage: ./create.sh mini.iso base.cfg

# Defaults
PARAMS=""

while [ "$1" != "" ]; do
    if [ "$1" == "-i" ]; then
	PARAMS="$PARAMS -i ${2}"; shift
    else
	PARAMS="$PARAMS -i mini.iso"; shift
    fi
    if [ "$1" == "-k" ]; then
        PARAMS="$PARAMS -k ${2}"; shift
    else
	PARAMS="$PARAMS -k base.cfg"; shift
    fi
    if [ "$1" == "-t" ]; then
        PARAMS="$PARAMS -t ${2}"; shift
    fi 
    if [ "$1" == "-e" ]; then
        PARAMS="$PARAMS -e ${2}"; shift
    fi
    shift
done

if [ "${1}" == "" ]; then
    PARAMS="-i mini.iso -k base.cfg"
fi

docker run --rm -v ${PWD}:/build -w "/build" --privileged=true -t cumorris/ubuntu1604 bash -c "./centos-build-media.sh ${PARAMS}"
