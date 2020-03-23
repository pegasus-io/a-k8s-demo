#/bin/bash

if [ "$(whoami)" == "root" ]; then
  echo "running [$0] as root"
else
  echo "you must run [$0] as root"
  exit 2
fi;

if [ "$(whoami)" == "root" ]; then
  echo "running [$0] as root"
else
  echo "you must run [$0] as root"
  exit 2
fi;





echo "VERIF OPERATOR_UID=[${OPERATOR_UID}] "
echo "VERIF OPERATOR_GID=[${OPERATOR_GID}] "
echo "VERIF BUMBLEBEE_LX_USERNAME=[${BUMBLEBEE_LX_USERNAME}] "
echo "VERIF BUMBLEBEE_LX_GROUPNAME=[${BUMBLEBEE_LX_GROUPNAME}] "

apk add --no-cache shadow sudo && \
    if [ -z "`getent group $OPERATOR_GID`" ]; then \
      addgroup -S -g ${OPERATOR_GID} ${BUMBLEBEE_LX_GROUPNAME}; \
    else \
      groupmod -n ${BUMBLEBEE_LX_GROUPNAME} `getent group $OPERATOR_GID | cut -d: -f1`; \
    fi && \
    if [ -z "`getent passwd $OPERATOR_UID`" ]; then \
      # users default shell will be bash, because I previously installed it in my alpine image
      adduser -S -u $OPERATOR_UID -G ${BUMBLEBEE_LX_GROUPNAME} -s /bin/bash ${BUMBLEBEE_LX_USERNAME}; \
    else \
      usermod -l ${BUMBLEBEE_LX_USERNAME} -g $OPERATOR_GID -d /home/${BUMBLEBEE_LX_USERNAME} -m `getent passwd $OPERATOR_UID | cut -d: -f1`; \
    fi && \
    echo "${BUMBLEBEE_LX_USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${BUMBLEBEE_LX_USERNAME} && \
    chmod 0440 /etc/sudoers.d/${BUMBLEBEE_LX_USERNAME}


chown :${BUMBLEBEE_LX_GROUPNAME} -R ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
chmod a-rwx -R ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
chmod g+rw -R ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
# Then we will have to make executable any file. By default, no file is executable.

echo ''
echo "Checking newly created user : "
echo ''
echo '----------------------------------------'
su beeio
whoami
id -u
id -g
echo " I am $(whoami) and my linux id is [$(id -g)] "
echo " I am $(whoami) and my main linux user group has id [$(id -g)] "
echo " I am $(whoami) and my home folder is [${HOME}] "
echo " I am $(whoami) I belong to linux groups [$(groups)] "

echo '----------------------------------------'

echo ''
echo "implementing that, still running on dev mode "
echo ''
# https://github.com/mhart/alpine-node/issues/48#issuecomment-370171836
# https://gitlab.com/second-bureau/pegasus/pegasus/-/issues/117
exit 99
