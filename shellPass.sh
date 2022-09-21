#!/usr/bin/env bash

#------------------------------------------------------------------------------|
# AUTOR             : Matheus Martins <3mhenrique@gmail.com>
# HOMEPAGE          : https://github.com/mateuscomh/shellPass
# DATE/VER.         : 29/08/2020 2.4
# LICENCE           : GPL3
# SHORT DESC        : Shell Script to generate fast passwords on terminal
# DEPS              : xclip on GNU/Linux / pbcopy on MacOS

#------------------------------------------------------------------------------|
export LANG=C
VERSION='2.4 by Matheus Martins'
USAGE="Program to generate on shell passwords whith alpanum on terminal

░▒█▀▀▀█░█░░░░█▀▀░█░░█░░▄▀▀▄░█▀▀▄░█▀▀░█▀▀
░░▀▀▀▄▄░█▀▀█░█▀▀░█░░█░░█▄▄█░█▄▄█░▀▀▄░▀▀▄
░▒█▄▄▄█░▀░░▀░▀▀▀░▀▀░▀▀░█░░░░▀░░▀░▀▀▀░▀▀▀ "
FECHA='\033[m'
VERDE='\033[32;1m'
VERMELHO='\033[31;1m'
AMARELO='\033[01;33m'
MAX=$1
#----------FUNC-------------------------------------------------------------|

_gerarsenha(){
if [ -z "$MAX" ] || [ "$MAX" -eq 0 ]; then
  clear
  echo -e "$USAGE \n"
  echo -e "${VERDE} Enter the QUANTITY of characters for the password: ${FECHA}"
  read -r MAX
fi

case $MAX in
  q|Q)
    echo -e "Quiting..."
    exit 0
    ;;
  ''|*[!0-9]*)
    echo -e "${VERMELHO} Enter only numbers referring to the SIZE of the password ${FECHA}"
    return 1
    ;;
  [0-9]*)
    echo -e "${VERDE} Enter the TYPE of password complexity you want: ${FECHA}
    ${AMARELO} 1 - Password only numbers ${FECHA}
    ${AMARELO} 2 - Password with LeTtErS and numb3rs ${FECHA}
    ${AMARELO} 3 - Password with LeTtErS, numb3rs and Speci@l Ch@r@ct&rs ${FECHA}"
    read -r TIPO

    case "$TIPO" in
      ''|*[!0-9]*)
        echo -e "${VERMELHO} Enter only numbers referring to the TYPE of the password ${FECHA}"
        return 2
        ;;
      1)
        PASS=$(cat /dev/urandom LC_ALL=C | tr -dc '0-9' | head -c "$MAX")
        command -v xclip > /dev/null && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy 2> /dev/null
        echo -e "${VERDE}$PASS${FECHA}"
        ;;
      2)
      PASS=$(cat /dev/urandom LC_ALL=C | tr -dc 'A-Za-z0-9' | head -c "$MAX")
      command -v xclip > /dev/null && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy 2> /dev/null
      echo -e "${VERDE}$PASS${FECHA}"
      ;;
      3)
        PASS=$(cat /dev/urandom LC_ALL=C |
          tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c "$MAX")
        command -v xclip > /dev/null && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy 2> /dev/null
        echo -e "${VERDE}$PASS${FECHA}"
        ;;
      *)
        echo -e "${VERMELHO} Use only the options [1,2,3] ${FECHA}"
        return 1
        ;;
    esac
esac
# write in file
echo "$(date '+%d/%m/%y %H:%M:%S') - $PASS" >> $(pwd)/history.log

}
#---------MAIN-------------------------------------------------------------------|

case "$MAX" in
  h | -h | --help )
    echo -e "$USAGE"
    exit 0
    ;;
  v | -v | --version )
    echo -e "${VERDE} $VERSION ${FECHA}"
    exit 0
    ;;
  '')
    OP='Y'
    while true; do
      if [[ "$OP" = [yYsS] ]]; then
        MAX=0
      _gerarsenha
        read -n 1 -p "Do you want to generate new password? [Y/n]" OP; echo
      elif [[ "$OP" = [nN] ]]; then
        break
      else
        echo -e "${VERMELHO} Invalid option ${FECHA}"
        read -n 1 -p "Do you want to generate new password? [Y/n]" OP; echo
      fi
    done
    ;;
  [0-9]*)
    _gerarsenha
    ;;
esac
