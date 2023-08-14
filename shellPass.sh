#!/usr/bin/env bash

#---------------------------------------------------------------------------|
# AUTOR             : Matheus Martins <3mhenrique@gmail.com>
# HOMEPAGE          : https://github.com/mateuscomh/shellPass
# DATE/VER.         : 29/08/2020 2.9.1
# LICENCE           : GPL3
# SHORT DESC        : Shell Script to generate fast passwords on terminal
# DEPS              : xclip in GNU/Linux / pbcopy in MacOS

#---------------------------------------------------------------------------|
export LANG=C
VERSION="2.9.1 by Matheus Martins"
USAGE="Program to generate on shell random passwords

███████╗██╗  ██╗███████╗██╗     ██╗     ██████╗  █████╗ ▄▄███▄▄·▄▄███▄▄·
██╔════╝██║  ██║██╔════╝██║     ██║     ██╔══██╗██╔══██╗██╔════╝██╔════╝
███████╗███████║█████╗  ██║     ██║     ██████╔╝███████║███████╗███████╗
╚════██║██╔══██║██╔══╝  ██║     ██║     ██╔═══╝ ██╔══██║╚════██║╚════██║
███████║██║  ██║███████╗███████╗███████╗██║     ██║  ██║███████║███████║
╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═▀▀▀══╝╚═▀▀▀══╝"
FECHA="\033[m"
BOLD=$(tput bold)
BLINK=$(tput blink)
ITALIC=$(tput dim)
MAX=$1
#----------FUNC-------------------------------------------------------------|
clear
echo -e "$USAGE \n"
_getsize(){
  while [[ -z "$MAX" || "$MAX" == *[^[:digit:]]* || "$MAX" -eq 0 ]];  do
    echo -e "${BOLD} Enter the QUANTITY of characters for the password or [Q]uit: ${FECHA}"
    read -r MAX
    [[ $MAX == [qQ] ]] && echo "bye.." && exit 0
  done
  return 0
}
_makepass(){
  case $MAX in
    q | Q)
      echo -e "Quiting..."
      exit 0
      ;;
    '' | *[!0-9]*)
      echo -e "${BLINK} Invalid option. ${FECHA}"
      _getsize
      ;;
    [0-9]*)
      echo -e "${BOLD} Enter the TYPE of password complexity you want: ${FECHA}
      ${ITALIC} 1 - Password only numbers ${FECHA}
      ${ITALIC} 2 - Password with LeTtErS and numb3rs ${FECHA}
      ${ITALIC} 3 - Password with LeTtErS, numb3rs and Speci@l Ch@r@ct&rs ${FECHA}";
      read -rsn 1 TIPO;

      case "$TIPO" in
        q | Q)
          echo -e "Bye.." && exit 0
          ;;
        '' | *[!0-9]*)
          echo -e "${BLINK} Enter only numbers referring to the TYPE of the password ${FECHA}"
          return 2
          ;;
        1)
          PASS=$(cat /dev/urandom LC_ALL=C | tr -dc '0-9' | head -c "$MAX")
          command -v xclip > /dev/null & printf %s "$PASS" | xclip -sel copy || printf %s "$PASS" | pbcopy 2> /dev/null
          echo -e "${BOLD}$PASS${FECHA}"
          ;;
        2)
        PASS=$(cat /dev/urandom LC_ALL=C | tr -dc 'A-Za-z0-9' | head -c "$MAX")
        command -v xclip > /dev/null & printf %s "$PASS" | xclip -sel copy || printf %s "$PASS" | pbcopy 2> /dev/null
        echo -e "${BOLD}$PASS${FECHA}"
        ;;
        3)
          PASS=$(cat /dev/urandom LC_ALL=C |
            tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c "$MAX")
          command -v xclip > /dev/null & printf %s "$PASS" | xclip -sel copy || printf %s "$PASS" | pbcopy 2> /dev/null
          echo -e "${BOLD}$PASS${FECHA}"
          ;;
        *)
          echo -e "${BLINK} Use only the options [1,2,3] ${FECHA}"
          return 1
          ;;
      esac
  esac
  _writeinfile
}

_writeinfile(){
  SCRIPT_PATH="${BASH_SOURCE:-$0}"
  ABS_SCRIPT_PATH="$(readlink -f "${SCRIPT_PATH}")"
  ABS_DIRECTORY="$(dirname "${ABS_SCRIPT_PATH}")"
  echo "$(date '+%d/%m/%y %H:%M:%S') - $PASS" >> "$ABS_DIRECTORY"/history.log 
}

_askprint(){
  read -rn 1 -p "[R]epeat, generate new password [Y/N] or [Q]uit program? [Y/N/R/Q]" OP; echo
}
#---------MAIN--------------------------------------------------------------|

case "$MAX" in
  h | -h | --help )
    echo -e "$USAGE"
    exit 0
    ;;
  v | -v | --version )
    echo -e "${BOLD} $VERSION ${FECHA}"
    exit 0
    ;;
  '')
    OP='Y'
    while true; do
      if [[ "$OP" = [yYsS] ]]; then
      MAX=0
      _getsize
      _makepass
      _askprint
      elif [[ "$OP" = [rR] ]]; then
        _getsize
        _makepass
        _askprint
      elif [[ "$OP" = [nNqQ] ]]; then
        echo -e "bye.."
        break
      else
        echo -e "${BLINK} Invalid option ${FECHA}"
        _askprint
      fi
    done
    ;;
  [0-9]*)
    _makepass
    ;;
  *[!0-9]*)
    echo -e "${BOLD} Invalid option, call again. ${FECHA}" && exit 1 
    ;;
esac
