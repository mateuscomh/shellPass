#!/usr/bin/env bash

#------------------------------------------------------------------------------|
# AUTOR             : Matheus Martins <3mhenrique@gmail.com>
# HOMEPAGE          : https://github.com/mateuscomh/shellPass
# DATE/VER.         : 29/08/2020 2.6
# LICENCE           : GPL3
# SHORT DESC        : Shell Script to generate fast passwords on terminal
# DEPS              : xclip on GNU/Linux / pbcopy on MacOS

#------------------------------------------------------------------------------|
export LANG=C
VERSION='2.6 by Matheus Martins'
USAGE="Program to generate on shell passwords whith alpanum on terminal
░▒█▀▀▀█░█░░░░█▀▀░█░░█░░▄▀▀▄░█▀▀▄░█▀▀░█▀▀
░░▀▀▀▄▄░█▀▀█░█▀▀░█░░█░░█▄▄█░█▄▄█░▀▀▄░▀▀▄
░▒█▄▄▄█░▀░░▀░▀▀▀░▀▀░▀▀░█░░░░▀░░▀░▀▀▀░▀▀▀ "
FECHA='\033[m'
BOLD=$(tput bold)
BLINK=$(tput blink)
ITALIC=$(tput dim)
MAX=$1
#----------FUNC-------------------------------------------------------------|
clear
_gettamanho(){
  echo -e "$USAGE \n"
  echo -e "${BOLD} Enter the QUANTITY of characters for the password or [Q] to quit: ${FECHA}"
  read -r MAX
}
_gerarsenha(){
case $MAX in
  q|Q)
    echo -e "Quiting..."
    exit 0
    ;;
  ''|*[!0-9]*)
    echo -e "${BLINK} Invalid option. ${FECHA}"
    _gettamanho
    ;;
  [0-9]*)
    echo -e "${BOLD} Enter the TYPE of password complexity you want: ${FECHA}
    ${ITALIC} 1 - Password only numbers ${FECHA}
    ${ITALIC} 2 - Password with LeTtErS and numb3rs ${FECHA}
    ${ITALIC} 3 - Password with LeTtErS, numb3rs and Speci@l Ch@r@ct&rs ${FECHA}";
    read -rsn 1 TIPO;

    case "$TIPO" in
      ''|*[!0-9]*)
        echo -e "${BLINK} Enter only numbers referring to the TYPE of the password ${FECHA}"
        return 2
        ;;
      1)
        PASS=$(cat /dev/urandom LC_ALL=C | tr -dc '0-9' | head -c "$MAX")
        command -v xclip > /dev/null && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy 2> /dev/null
        echo -e "${BOLD}$PASS${FECHA}"
        ;;
      2)
      PASS=$(cat /dev/urandom LC_ALL=C | tr -dc 'A-Za-z0-9' | head -c "$MAX")
      command -v xclip > /dev/null && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy 2> /dev/null
      echo -e "${BOLD}$PASS${FECHA}"
      ;;
      3)
        PASS=$(cat /dev/urandom LC_ALL=C |
          tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c "$MAX")
        command -v xclip > /dev/null && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy 2> /dev/null
        echo -e "${BOLD}$PASS${FECHA}"
        ;;
      *)
        echo -e "${BLINK} Use only the options [1,2,3] ${FECHA}"
        return 1
        ;;
    esac
esac
# write in file
echo "$(date '+%d/%m/%y %H:%M:%S') - $PASS" >> /gitclones/shellPass/history.log

}
_askprint(){
  read -rn 1 -p "[R]epeat, generate new password [Y/N] or [Q]uit program? [Y/N/R/Q]" OP; echo
}
#---------MAIN-------------------------------------------------------------------|

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
      _gettamanho
      _gerarsenha
      _askprint
      elif [[ "$OP" = [rR] ]]; then
        _gettamanho
        _gerarsenha
        _askprint
      elif [[ "$OP" = [nNqQ] ]]; then
        break
      else
        echo -e "${BLINK} Invalid option ${FECHA}"
        _askprint
      fi
    done
    ;;
  [0-9]*)
    _gerarsenha
    ;;
esac
