#!/bin/bash


export AWSCLI_OPERATOR_CONTAINER_NAME=${AWSCLI_OPERATOR_CONTAINER_NAME:-'awscli_bee'}

# just a wait,but healthchecking willbe used instead :

# returns 0 if container is of status ["healthy"]
# returns 1 in any other case.
checkHealthOf () {
  export CONTAINER_TO_CHECK_NAME=$1
  export HEALTHCHECK_ANSWER=''
  if [ "x$CONTAINER_TO_CHECK_NAME" == "x" ];then
    echo "Checking name of container (empty name) [CONTAINER_TO_CHECK_NAME=$CONTAINER_TO_CHECK_NAME] ... " | tee ANSWERCONTAINER_NAME.speak
    echo "You should provide one and only one argument to the [checkHealthOf] function, the name of the container you want to check the healt of"
    return 1;
  else
    echo "Checking name of container (not empty name) [CONTAINER_TO_CHECK_NAME=$CONTAINER_TO_CHECK_NAME] ...  " | tee ANSWERCONTAINER_NAME.speak
    export HEALTHCHECK_ANSWER=$(docker inspect $CONTAINER_TO_CHECK_NAME | jq '.[]' | jq '.Status.Health')
    echo "Health of container [$CONTAINER_TO_CHECK_NAME] is [$HEALTHCHECK_ANSWER] " | tee -a ANSWERCONTAINER_NAME.speak
    if [ "$HEALTHCHECK_ANSWER" == 'healthy' ];then
      return 0;
    else
      return 1;
    fi;
  fi;
}


##### JSON PARSING examples
#
# ### Dockerfile
#
# HEALTHCHECK CMD curl --fail http://localhost:5000/ || exit 1
#
# ###
# answer1.json :
# {"Status":"Starting","FailingStreak":0,"Log":[]}
#
# ###
# answer2.json :
# {"Status":"healthy","FailingStreak":0,"Log":[{"Start":"2017-07-21T06:10:51.809087707Z","End":"2017-07-21T06:10:51.868940223Z","ExitCode":0,"Output":"Hello world"}]}
#
#
# cat answer1.json | jq '.Status'
#
# cat answer2.json | jq '.Status'
#

export IS_SERVICE_HEALTHY=1
while [ "$IS_SERVICE_HEALTHY" != "0" ]
do
  echo "checking health of the [$AWSCLI_OPERATOR_CONTAINER_NAME] container ..." | tee ANSWERCONTAINER_NAME.speak
  export IS_SERVICE_HEALTHY=$(checkHealthOf $AWSCLI_OPERATOR_CONTAINER_NAME)
  sleep 1s
done
