#!/bin/bash
#
# db_docker_util.sh - helper script for running mysql in a docker container
#
# Notes:
#
#   run this script as 'db_docker_util.sh (start|schema|cli)'
#
#   root password needs to be set in the environment as MYSQL_ROOT_PW
#
#   some of the configuration (schema file, data dir) is hard-coded into the script
#

# name of the container to create and use
CONTAINER_NAME=example_db_server

# location of the db files
DB_DATA_LOC=/opt/data/example

# where this script expects to find the schema file
SCHEMA_FILE=src/sql/schema.sql

# which docker image and version tag to use
DB_IMAGE=mysql
DB_IMAGE_TAG=latest


# root pw is taken from environment
PW=$MYSQL_ROOT_PW
if [[ -z $PW ]]; then
    echo db pw not set. Must be set in MYSQL_ROOT_PW env var
    exit
fi

# first positional arg is used to determine action to execute
# should be 'start' or 'schema'
COMMAND=$1

if [[ $COMMAND == 'start' ]]; then
  echo starting server;
  docker run -d --name $CONTAINER_NAME -v $DB_DATA_LOC:/var/lib/mysql -e "MYSQL_ROOT_PASSWORD=$PW" $DB_IMAGE:$DB_IMAGE_TAG
elif [[ $COMMAND == 'schema' ]]; then
  echo creating schema
  docker exec -i $CONTAINER_NAME sh -c "exec mysql -uroot -p\"$PW\"" < $SCHEMA_FILE
elif [[ $COMMAND == 'cli' ]]; then
    echo creating shell
    docker exec -it $CONTAINER_NAME sh -c "exec mysql -uroot -p"
else
    echo no command found. available commands are start, schema, and cli
fi


