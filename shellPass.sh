#!/usr/bin/env bash
export LANG=C
#---------------------------------------------------------------------------|
# AUTOR             : Matheus Martins <3mhenrique@gmail.com>
# HOMEPAGE          : https://github.com/mateuscomh/shellPass
# DATE/VER.         : 29/08/2020 3.0
# LICENCE           : GPL3
# SHORT DESC        : Shell Script to generate fast passwords on terminal
# DEPS              : xclip in GNU/Linux / pbcopy in MacOS
#---------------------------------------------------------------------------|
FECHA="\033[m"
BOLD=$(tput bold)
ITALIC=$(tput dim)

_checkSize(){
  while [[ -z "$MAX" || "$MAX" == *[^[:digit:]]* || "$MAX" -eq 0 ]];  do
    echo -e "${BOLD} Enter the QUANTITY of characters for the password or [Q]uit: ${FECHA}"
    read -r MAX
    [[ $MAX == [qQ] ]] && echo "Bye..." && exit 0
  done
}

_checkType(){
  while [[ "$TIPO" != [1-3] && "$TIPO" != [qQ] ]]; do
    echo -e "${BOLD} Enter the TYPE of password complexity you want: ${FECHA}
    ${ITALIC} 1 - Password only numbers ${FECHA}
    ${ITALIC} 2 - Password with LeTtErS and numb3rs ${FECHA}
    ${ITALIC} 3 - Password with LeTtErS, numb3rs and Speci@l Ch@r@ct&rs ${FECHA}"
    read -rsn 1 TIPO;
  done
}

_writeinfile(){
  SCRIPT_PATH="${BASH_SOURCE:-$0}"
  ABS_SCRIPT_PATH="$(readlink -f "${SCRIPT_PATH}")"
  ABS_DIRECTORY="$(dirname "${ABS_SCRIPT_PATH}")"
  echo "$(date '+%d/%m/%y %H:%M:%S') - $PASS" >> "$ABS_DIRECTORY"/history.log 
}

_makePass(){
  PASS=$(cat /dev/urandom LC_ALL=C | tr -dc "$CPX"| head -c "$MAX")
  command -v xclip > /dev/null & printf %s "$PASS" | xclip -sel copy || printf %s "$PASS" | pbcopy 2> /dev/null
  echo -e "${BOLD}$PASS${FECHA}"
}

main(){
  local VERSION="3.0 by Matheus Martins"
  local USAGE="Program to generate random passwords on CLI
███████╗██╗  ██╗███████╗██╗     ██╗     ██████╗  █████╗ ▄▄███▄▄·▄▄███▄▄·
██╔════╝██║  ██║██╔════╝██║     ██║     ██╔══██╗██╔══██╗██╔════╝██╔════╝
███████╗███████║█████╗  ██║     ██║     ██████╔╝███████║███████╗███████╗
╚════██║██╔══██║██╔══╝  ██║     ██║     ██╔═══╝ ██╔══██║╚════██║╚════██║
███████║██║  ██║███████╗███████╗███████╗██║     ██║  ██║███████║███████║
╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═▀▀▀══╝╚═▀▀▀══╝"
  MAX="$1"
  TIPO="$2"
  echo -e "$USAGE"
  case "$MAX" in
    h | -h | --help )
      echo -e "$USAGE"
      exit 0 ;;
    v | -v | --version )
      echo -e "${BOLD} $VERSION ${FECHA}"
      exit 0 ;;
    * )
      _checkSize 
      _checkType ;;
  esac

  case "$TIPO" in
    1) 
      CPX='0-9' ;;
    2)
      CPX='a-z0-9A-Z' ;;
    3)
      CPX='A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' ;;
    q|Q)
      echo "Bye..."
      exit 0 ;;
  esac

  _makePass
  _writeinfile
}
#---Main
main "$1" "$2"