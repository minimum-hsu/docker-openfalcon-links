#!/bin/bash

WAIT_SERVICE_READY=10

function check_service(){
  status=$($WORKDIR/control status)
  echo $status | grep -q "stoped"
  if [ $? -eq 0 ] ; then
    return 1
  else
    return 0
  fi
}

tar -zxf $PACKDIR/$PACKFILE -C $WORKDIR
cp $CONFIGDIR/$CONFIGFILE $WORKDIR/frame/$CONFIGFILE
virtualenv $WORKDIR/env
pip install -r /home/links/pip_requirements.txt -i http://pypi.douban.com/simple
$WORKDIR/control restart
sleep $WAIT_SERVICE_READY
check_service
if [ $? -eq 0 ] ; then
  $WORKDIR/control tail
else
  echo "Failed to start."
  exit 1
fi
