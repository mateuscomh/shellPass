#!/usr/bin/env bash

#-----------HEADER-------------------------------------------------------------|
# AUTOR             : Matheus Martins 3mhenrique@gmail.com
# HOMEPAGE          : https://github.com/mateuscomh 
# DATA CRIAÇÃO      : 29/08/2020 
# PROGRAMA          : Shell-Base
# VERSÃO            : 1.1
# LICENÇA           : GPL3
# PEQUENA-DESCRI��O : Programa para criar senhas seguras via terminal
#
# CHANGELOG :
#
# 29/08/2020 18:00 - Adicionada valida��o de apenas n�mero a ser recebido pelo usu�rio
#                  - Adicionado cabe�alho para commit no git
# 30/08/2020 13:00 - Adicionado status de help e versao
# 12/04/2020 14:00 - Ajustes de grafia no output de erro de senha
#                  - Melhoria na função de identificar input 
#
#----------FIM-HEADER---------------------------------------------------------|
fecha="\033[m"
verde="\033[32;1m"
vermelho="\033[31;1m"
amarelo="\033[01;33m"

#----------FUNCOES------------------------------------------------------------|
gerarsenha(){

echo "$verde Informe a quantidade de caracteres para a ser gerada $fecha"
read max

case $max in
  ''|*[!0-9]*) echo "$vermelho Insira apenas números referente ao tamanho da senha a ser gerada $fecha" >&2
  exit 1;;
  *)
    echo "$vermelho Senha gerada: $amarelo"
    </dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c $max  ; echo "$fecha" 
    ;;
esac
}
#----------FIM-FUNCOES--------------------------------------------------------|

case "$1" in
  -h | --help ) echo "Programa para gerar passwords com complexida alfanum�rica e com cacteres especiais rapidamente via terminal"
               echo "Autor mateuscomh/Django"
               exit 0 ;;
  -v | --version ) echo "Vers�o 1.1"
                  exit 0 ;;
 '') gerarsenha 
  ;;
  *) echo "$vermelho Opção inválida $fecha"
      exit 1 ;;
esac
