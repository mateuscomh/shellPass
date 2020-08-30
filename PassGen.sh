#!/bin/env bash

#-----------HEADER-------------------------------------------------------------|
# AUTOR             : Matheus Martins 3mhenrique@gmail.com
# HOMEPAGE          : https://github.com/mateuscomh 
# DATA CRIAÇÃO      : 29/08/2020 
# PROGRAMA          : Shell-Base
# VERSÃO            : 1.0.2
# LICENÇA           : GPL3
# PEQUENA-DESCRIÇÃO : Programa para criar senhas seguras via terminal
#
# CHANGELOG :

# 29/08/2020 18:00 - Adicionada validação de apenas número a ser recebido pelo usuário
#                  - Adicionado cabeçalho para commit no git
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
  ''|*[!0-9]*) echo "$vermelho Informe apenas com números o tamanho da senha a ser gerada $fecha" >&2
  exit 1;;
  *)
    echo "$amarelo"
    </dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c $max  ; echo "$fecha" 
    ;;
esac
}
#----------FIM-FUNCOES--------------------------------------------------------|
#Executando...
gerarsenha
