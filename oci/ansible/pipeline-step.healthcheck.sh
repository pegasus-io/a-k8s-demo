#!/bin/bash



#
echo " # ++++++++++++++++++++++++++++++++++++++++++++++++++ # "
echo " # ++++++++++++++++++++++++++++++++++++++++++++++++++ # "
echo "     Pipeline Healthcheck for Init Step completion : "
echo "        [HEALTH_CHECK_FILE=[$HEALTH_CHECK_FILE]]"
echo "                         ...  "
echo " # ++++++++++++++++++++++++++++++++++++++++++++++++++ # "
echo " # ++++++++++++++++++++++++++++++++++++++++++++++++++ # "

# To make it finer... :
export HEALTH_CHECK_FILE=$BUMBLEBEE_HOME_INSIDE_CONTAINER/PIPELINE_STEP_SUCCESS.init.healthcheck


if [ -f $HEALTH_CHECK_FILE ]; then
  echo "Pipeline Build Step has sucessfully completed [HEALTH_CHECK_FILE=[$HEALTH_CHECK_FILE]]."
  exit 0
else
  echo "Pipeline Build Step has not yet been successfully completed"
  exit 3
fi;

# export BUILD_CHECK_FILE=$BUMBLEBEE_HOME_INSIDE_CONTAINER/PIPELINE_STEP_SUCCESS.build.healthcheck

# if [ -f $BUILD_CHECK_FILE ]; then
  # echo "Pipeline Build Step has sucessfully completed HEALTH_CHECK_FILE."
  # exit 0
# else
  # echo "Pipeline Build Step has not yet been successfully completed"
  # exit 3
# fi;
