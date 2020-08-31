#!/bin/env bash

#-----------HEADER-------------------------------------------------------------|
# AUTOR             : Matheus Martins 3mhenrique@gmail.com
# HOMEPAGE          : https://github.com/mateuscomh 
# DATA CRIAÇÃO      : 29/08/2020 
# PROGRAMA          : Shell-Base
# VERSÃO            : 1.1.3
# LICENÇA           : GPL3
# PEQUENA-DESCRIÇÃO : Programa para criar senhas seguras via terminal
#
# CHANGELOG :
#
# 29/08/2020 18:00 - Adicionada validação apenas número a ser recebido pelo usuário.
#                  - Adicionado cabeçalho para commit no git.
# 30/08/2020 13:00 - Adicionado status de help e versao.
# 31/08/2020 18:00 - Função case com problemas de repetição e sem fluxo lógico - corrigido.
#
#----------FIM-HEADER---------------------------------------------------------|
fecha="\033[m"
verde="\033[32;1m"
vermelho="\033[31;1m"
amarelo="\033[01;33m"
#----------FUNCOES------------------------------------------------------------|
gerarsenha(){

echo "$verde Informe a quantidade de caracteres para a ser gerada ou 0 para sair $fecha"
read max

case $max in
  ''|*[!0-9]*) echo "$vermelho Informe apenas com números o tamanho da senha a ser gerada $fecha" >&2
  exit 1;;
  0) exit 0 ;;
  *)
    echo "$vermelho Senha gerada: $amarelo"
    </dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c $max  ; echo "$fecha" 
    ;;
esac
}
#----------FIM-FUNCOES--------------------------------------------------------|
#Executando...
case "$1" in
  -h | --help ) echo "Programa para gerar passwords com complexida alfanum�rica e com cacteres especiais rapidamente via terminal"
               echo "Autor mateuscomh - Django"
               exit 0 ;;
  -v | --version ) echo "Vers�o 1.1"
                  exit 0 ;;
  '') gerarsenha 
      exit 0 ;;
  *) echo "$vermelho Op��o inv�lida $fecha"
      exit 1 ;;
esac
