#/bin/bash

if [ "$(whoami)" == "root" ]; then
  echo "running [$0] as root"
else
  echo "you must run [$0] as root"
  exit 2
fi;

useradd ${BUMBLEBEE_LX_USERNAME}

echo ''
echo "implementing that, still running on dev mode "
echo ''

# https://github.com/mhart/alpine-node/issues/48#issuecomment-370171836
# https://gitlab.com/second-bureau/pegasus/pegasus/-/issues/117
exit 99
