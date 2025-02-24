#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#===========================================================================================
# Java Environment Setting
#===========================================================================================
error_exit ()
{
    echo "ERROR: $1 !!"
    exit 1
}

[ ! -e "$JAVA_HOME/bin/java" ] && JAVA_HOME=$HOME/jdk/java
[ ! -e "$JAVA_HOME/bin/java" ] && JAVA_HOME=/usr/java
[ ! -e "$JAVA_HOME/bin/java" ] && error_exit "Please set the JAVA_HOME variable in your environment, We need java(x64)!"

export JAVA_HOME
export JAVA="$JAVA_HOME/bin/java"
export BASE_DIR=$(dirname $0)/..
export CLASSPATH=.:${BASE_DIR}/conf:${CLASSPATH}

#===========================================================================================
# JVM Configuration
#===========================================================================================
# Get the max heap used by a jvm, which used all the ram available to the container.
if [ -z "$MAX_POSSIBLE_HEAP" ]
then
	MAX_POSSIBLE_RAM_STR=$(java -XX:+UnlockExperimentalVMOptions -XX:MaxRAMFraction=1 -XshowSettings:vm -version 2>&1 | awk '/Max\. Heap Size \(Estimated\): [0-9KMG]+/{ print $5}')
	MAX_POSSIBLE_RAM=$MAX_POSSIBLE_RAM_STR
	CAL_UNIT=${MAX_POSSIBLE_RAM_STR: -1}
	if [ "$CAL_UNIT" == "G" -o "$CAL_UNIT" == "g" ]; then
		MAX_POSSIBLE_RAM=$(echo ${MAX_POSSIBLE_RAM_STR:0:${#MAX_POSSIBLE_RAM_STR}-1} `expr 1 \* 1024 \* 1024 \* 1024` | awk '{printf "%d",$1*$2}')
	elif [ "$CAL_UNIT" == "M" -o "$CAL_UNIT" == "m" ]; then
		MAX_POSSIBLE_RAM=$(echo ${MAX_POSSIBLE_RAM_STR:0:${#MAX_POSSIBLE_RAM_STR}-1} `expr 1 \* 1024 \* 1024` | awk '{printf "%d",$1*$2}')
	elif [ "$CAL_UNIT" == "K" -o "$CAL_UNIT" == "k" ]; then
		MAX_POSSIBLE_RAM=$(echo ${MAX_POSSIBLE_RAM_STR:0:${#MAX_POSSIBLE_RAM_STR}-1} `expr 1 \* 1024` | awk '{printf "%d",$1*$2}')
	fi
	MAX_POSSIBLE_HEAP=$[MAX_POSSIBLE_RAM/4]
fi

# Dynamically calculate parameters, for reference.
Xms=$MAX_POSSIBLE_HEAP
Xmx=$MAX_POSSIBLE_HEAP
Xmn=$[MAX_POSSIBLE_HEAP/2]
# Set for `JAVA_OPT`.
JAVA_OPT="${JAVA_OPT} -server "
if [ x"${MAX_POSSIBLE_HEAP_AUTO}" = x"auto" ];then
    JAVA_OPT="${JAVA_OPT} -Xms${Xms} -Xmx${Xmx} -Xmn${Xmn}"
fi
#-XX:+UseCMSCompactAtFullCollection
#JAVA_OPT="${JAVA_OPT} -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSClassUnloadingEnabled -XX:SurvivorRatio=8 "
#JAVA_OPT="${JAVA_OPT} -verbose:gc -Xloggc:/dev/shm/rmq_srv_gc.log -XX:+PrintGCDetails"
#JAVA_OPT="${JAVA_OPT} -XX:-OmitStackTraceInFastThrow"
#JAVA_OPT="${JAVA_OPT}  -XX:-UseLargePages"
#JAVA_OPT="${JAVA_OPT} -Djava.ext.dirs=${JAVA_HOME}/jre/lib/ext:${BASE_DIR}/lib"
#JAVA_OPT="${JAVA_OPT} -Xdebug -Xrunjdwp:transport=dt_socket,address=9555,server=y,suspend=n"
JAVA_OPT="${JAVA_OPT} -Dserver.port=${PORT} "
JAVA_OPT="${JAVA_OPT} -Dcsp.sentinel.log.dir=${SENTINEL_LOGS} "
JAVA_OPT="${JAVA_OPT} -Djava.security.egd=file:/dev/./urandom"
JAVA_OPT="${JAVA_OPT} -Dproject.name=${PROJECT_NAME} "
JAVA_OPT="${JAVA_OPT} -Dcsp.sentinel.app.type=1 "
JAVA_OPT="${JAVA_OPT} -Dsentinel.dashboard.auth.username=${USERNAME} "
JAVA_OPT="${JAVA_OPT} -Dsentinel.dashboard.auth.password=${PASSWORD} "
JAVA_OPT="${JAVA_OPT} -Dcsp.sentinel.dashboard.server=${SERVER_HOST:-localhost}:${SERVER_PORT:-8858} "
JAVA_OPT="${JAVA_OPT} ${JAVA_OPT_EXT}"
JAVA_OPT="${JAVA_OPT} -jar sentinel-dashboard.jar "
JAVA_OPT="${JAVA_OPT} -cp ${CLASSPATH}"
echo "JAVA_OPT============"
echo "JAVA_OPT============"
echo "JAVA_OPT============"
echo $JAVA_OPT

$JAVA ${JAVA_OPT} $@


