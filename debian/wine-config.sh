#!/bin/bash -e
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.

# Usage: dude-compose.sh [workspace directory]
#     ENV: WORKSPACE - if variable exists, will be used as the WORKSPACE Directory
#     ENV: YAML_FILE - if variable exists, will be used to specify the location of the YAML_FILE

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TARGET="$(readlink "$SOURCE")"
  if [[ $TARGET == /* ]]; then
    echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
    SOURCE="$TARGET"
  else
    DIR="$( dirname "$SOURCE" )"
    echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')"
    SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  fi
done
echo "SOURCE is '$SOURCE'"
RDIR="$( dirname "$SOURCE" )"
BASE_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
if [ "$BASE_DIR" != "$RDIR" ]; then
  echo "DIR '$RDIR' resolves to '$BASE_DIR'"
fi
echo "DIR is '$BASE_DIR'"

export COMPOSE_FILE=${YAML_FILE:-${BASE_DIR}/docker-compose.yml}
echo "COMPOSE_FILE set to '$COMPOSE_FILE'"

# The first parameter will set the WORKSPACE variable, if it exists
if [[ ! -z $1 ]]; then
    WORKSPACE=$1
fi
 
# If WORKSPACE not set, create a directory in user's home directory based on the directory where the script exists
export WORKSPACE_DIR=${WORKSPACE:-~/`basename "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"`}
echo "WORKSPACE_DIR set to '$WORKSPACE_DIR'"

# Create the directory if it does not exist
if [[ ! -d ${WORKSPACE_DIR} ]]; then
    echo "Creating ${WORKSPACE_DIR}..."
    mkdir -p ${WORKSPACE_DIR}
fi

export COMMAND="winecfg"

CMD="docker-compose --verbose up"

echo $CMD
cd ${BASE_DIR} && $CMD
