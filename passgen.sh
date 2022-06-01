#!/usr/bin/env bash

#-----------HEADER-------------------------------------------------------------|
# AUTOR             : Matheus Martins <3mhenrique@gmail.com>
# HOMEPAGE          : https://github.com/mateuscomh
# DATA/VER.         : 29/08/2020 1.8
# LICENÇA           : GPL3
# PEQUENA-DESCRICÃO : Script em shell para criação de senhas
# REQUISITOS        : xclip

#----------FIM-HEADER----------------------------------------------------------|
FECHA='\033[m'
VERDE='\033[32;1m'
VERMELHO='\033[31;1m'
AMARELO='\033[01;33m'
MAX=$1
export LANG=C
#export LC_CTYPE=C
#----------FUNCOES-------------------------------------------------------------|
_gerarsenha(){
if [ -z "$MAX" ] || [ "$MAX" -eq 0 ]; then
  echo -e "${VERDE} Informe a QUANTIDADE de caracteres para senha: ${FECHA}"
  read -r MAX
fi

case $MAX in
  ''|*[!0-9]*)
    echo -e "${VERMELHO} Insira apenas números referente ao TAMANHO da senha ${FECHA}"
    return 1
    ;;
  [0-9]*)
    echo -e "${VERDE} Informe o TIPO da complexidade de senha que deseja: ${FECHA}
    ${AMARELO} 1 - Senha apenas números ${FECHA}
    ${AMARELO} 2 - Senha com LeTrAs e números ${FECHA}
    ${AMARELO} 3 - Senha com LeTrAs, números e caracteres especiais ${FECHA}"
    read -r TIPO

  case "$TIPO" in
    ''|*[!0-9]*)
      echo -e "${VERMELHO} Insira apenas números referente ao TIPO da senha ${FECHA}"
      return 2
      ;;
    1)
      PASS=$(cat /dev/urandom LC_ALL=C | tr -dc '0-9' | head -c "$MAX")
      command -v xclip && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy
      echo -e "${VERDE}$PASS${FECHA}"
      ;;
    2)
      PASS=$(cat /dev/urandom LC_ALL=C | tr -dc 'A-Za-z0-9' | head -c "$MAX")
      command -v xclip && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy
      #echo -n "$PASS" | xclip -sel copy
      echo -e "${VERDE}$PASS${FECHA}"
      ;;
    3)
      PASS=$(cat /dev/urandom LC_ALL=C |
        tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c "$MAX")
      command -v xclip && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy
      echo -e "${VERDE}$PASS${FECHA}"
      ;;
    *)
      echo -e "${VERMELHO} Utilizar as opcoes [4,2,3] ${FECHA}"
      return 1
      ;;
  esac
esac
}

#----------FIM-FUNCOES---------------------------------------------------------|
case "$MAX" in
  -h | --help )
    echo -e "${VERDE} Programa para gerar passwords com complexidade
    alfanumérica e com caracteres especiais rapidamente via terminal ${FECHA}"
    echo -e "${VERDE} Autor mateuscomh vulgo Django ${FECHA}"
    exit 0
    ;;
  -v | --version )
    echo -e "${VERDE} Versão 1.7 ${FECHA}"
    exit 0
    ;;
  '')
    OP=s
    while true; do
      if [[ "$OP" = [sS] ]]; then
        MAX=0
      _gerarsenha
        read -n 1 -p "Deseja gerar nova senha? [s/n]" OP; echo
      elif [[ "$OP" = [nN] ]]; then
        break
      else
        echo -e "${VERMELHO} Opção inválida ${FECHA}"
        read -n 1 -p "Deseja gerar nova senha? [s/n]" OP; echo
      fi
    done
    ;;
  [0-9]*)
    _gerarsenha
    ;;
esac
