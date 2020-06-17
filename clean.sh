#!/bin/bash

docker_cleanup_images () {
  # remove <none> tagged images
  DELETED_IMG_IDS="$(docker rmi -f $(docker images | grep "<none>" \
    | awk "{print \$3}") 2>&1)"
  NONE_DELETED="$(expr "${DELETED_IMG_IDS}" :  '.*least')"

  if [ "${NONE_DELETED}" = "0" ]; then
    echo "'docker rmi' completed execution.\
      \n${B_GREEN}Deleted images:${NONESTYLE}\n${DELETED_IMG_IDS}"
  else
    echo "'docker rmi' completed execution.\
      \n${BOLD}No temporary images to delete.${NONESTYLE}"
  fi
}

docker_cleanup_containers () {
  # remove run temporary container
  local OUTPUT=""
  for pattern in "/" "-" "*'*'"
  do
    DELETED_CONT_IDS="$(docker rm -f $(docker ps -a | grep "\"${pattern}" \
      | awk "{print \$1}") 2>&1)"
    NONE_DELETED="$(expr "${DELETED_CONT_IDS}" :  '.*least')"

    if [ "${NONE_DELETED}" = "0" ]; then
      OUTPUT="${OUTPUT}${DELETED_CONT_IDS}"
    fi
  done

  if [ "${OUTPUT}" = "" ]; then
    echo "'docker rm' completed execution.\
      \n${BOLD}No temporary containers to delete.${NONESTYLE}"
  else
    echo "'docker rm' completed execution. ${B_GREEN}\
        \nDeleted containers:${NONESTYLE}\n${OUTPUT}"
  fi
}


main () {
  docker_cleanup_images
  echo " "
  docker_cleanup_containers
}

#style
NONESTYLE='\e[0m'
BOLD='\e[1m'
B_GREEN='\e[1;32m'
B_YELLOW='\e[1;33m'

#run script
main
