#!/usr/bin/env bash

export LANG=C
#----------------------------------------------------|
#  Matheus Martins 3mhenrique@gmail.com
#  https://github.com/mateuscomh/yoURL
#  30/03/2021 3.1 GPL3
#  Generate secure passwords on terminal
#  Depends: xclip on GNU/Linux / pbcopy on IOS
#----------------------------------------------------|

FECHA="\033[m"
BOLD=$(tput bold)
ITALIC=$(tput dim)

main() {
  local VERSION="Ver:3.1 by Matheus Martins"
  local USAGE="Program to generate random passwords on CLI
███████╗██╗  ██╗███████╗██╗     ██╗     ██████╗  █████╗ ▄▄███▄▄·▄▄███▄▄·
██╔════╝██║  ██║██╔════╝██║     ██║     ██╔══██╗██╔══██╗██╔════╝██╔════╝
███████╗███████║█████╗  ██║     ██║     ██████╔╝███████║███████╗███████╗
╚════██║██╔══██║██╔══╝  ██║     ██║     ██╔═══╝ ██╔══██║╚════██║╚════██║
███████║██║  ██║███████╗███████╗███████╗██║     ██║  ██║███████║███████║
╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═▀▀▀══╝╚═▀▀▀══╝ "
  local MAX="$1"
  local TIPO="$2"
  echo -e "$USAGE"
  case "$MAX" in
    v | -v | --version )  echo -e "${BOLD} $VERSION ${FECHA}"; exit;;
    * ) _checkSize; _checkType ;;
  esac

  case "$TIPO" in
    1) 
        CPX='0-9' ;;
    2) 
        CPX='a-z0-9A-Z' ;;
    3) 
        CPX='A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' ;;
    q|Q) echo "Bye..."; exit ;;
  esac
  _makePass
  _writeinfile
}

_checkSize() {
  while [[ -z "$MAX" || "$MAX" == *[^[:digit:]]* || "$MAX" -lt 1 ]];  do
    echo -e "${BOLD} Enter the QUANTITY of characters for the password or [Q]uit: ${FECHA}"
    read -r MAX
    [[ $MAX == [qQ] ]] && echo "Bye..." && exit 0
  done
}

_checkType() {
  while [[ "$TIPO" != [1-3] && "$TIPO" != [qQ] ]]; do
    echo -e "${BOLD} Enter the TYPE of password complexity you want: ${FECHA}
    ${ITALIC} 1 - Password only numbers ${FECHA}
    ${ITALIC} 2 - Password with LeTtErS and numb3rs ${FECHA}
    ${ITALIC} 3 - Password with LeTtErS, numb3rs and Speci@l Ch@r@ct&rs ${FECHA}"
    read -rsn 1 TIPO;
  done
}

_writeinfile() {
  SCRIPT_PATH="${BASH_SOURCE:-$0}"
  ABS_SCRIPT_PATH="$(readlink -f "${SCRIPT_PATH}")"
  ABS_DIRECTORY="$(dirname "${ABS_SCRIPT_PATH}")"
  echo "$(date '+%d/%m/%y %H:%M:%S') - $PASS" >> "$ABS_DIRECTORY"/history.log 
}

_makePass() {
  PASS=$(cat /dev/urandom LC_ALL=C | tr -dc "$CPX"| head -c "$MAX")
  case $(uname -s) in
    Darwin) printf %s "$PASS" | pbcopy 2> /dev/null ;;
    Linux) command -v xclip > /dev/null && { printf %s "$PASS" | xclip -sel copy; } ;;
    *) echo "This is compatible only for GNU/Linux, MacOS or WSL2"; exit 1 ;;
  esac
  echo -e "${BOLD}$PASS${FECHA}"
}
#---Main
main "$1" "$2"
