#!/usr/bin/env bash

#-----------HEADER-------------------------------------------------------------|
# AUTOR             : Matheus Martins 3mhenrique@gmail.com
# HOMEPAGE          : https://github.com/mateuscomh 
# DATA CRIAÇÃO      : 29/08/2020 
# PROGRAMA          : Shell-Base
# VERSÃO            : 1.2
# LICENÇA           : GPL3
# PEQUENA-DESCRICÃO: Programa para criar senhas seguras via terminal
#
# CHANGELOG :
# 29/08/2020 18:00 - Adicionada validaçãoo de apenas número a ser recebido pelo usuário
#                  - Adicionado cabeçalho para commit no git
# 30/08/2020 13:00 - Adicionado status de help e versao
# 09/09/2021 10:00 - Implementado recurso de escolha de tipos de senha
#                  - Atualizado no repositorio GIT e renomeado para fácil acesso
#
#----------FIM-HEADER---------------------------------------------------------|
fecha="\033[m"
verde="\033[32;1m"
vermelho="\033[31;1m"
amarelo="\033[01;33m"

#----------FUNCOES------------------------------------------------------------|
gerarsenha(){

echo "$verde Informe a QUANTIDADE de caracteres para a ser gerada: $fecha"
read max

case $max in
  ''|*[!0-9]*) echo "$vermelho Insira apenas números referente ao TAMANHO da senha a ser gerada $fecha" >&2
  exit 1;;
  [0-9]*) echo "$verde Informe o TIPO da complexidade de senha que deseja: $fecha
$amarelo 1 - Senha apenas números $fecha
$amarelo 2 - Senha com LeTrAs e números $fecha
$amarelo 3 - Senha com LeTrAs, números e caracteres especiais $fecha"
read tipo
	echo $tipo
	case $tipo in
		''|*[!0-9]*) echo "$vermelho Insira apenas números referente ao TIPO da senha a ser gerada $fecha" >&2
		exit 1;;
		1) echo "$vermelho Senha gerada: $amarelo"
			</dev/urandom tr -dc '0-9' | head -c $max  ; echo "$fecha"
			;;
		2) echo "$vermelho Senha gerada: $amarelo"
			</dev/urandom tr -dc 'A-Za-z0-9' | head -c $max  ; echo "$fecha" 
			;;
		3) echo "$vermelho Senha gerada: $amarelo"
			</dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c $max  ; echo "$fecha" 
    ;;
	esac
esac
}
#----------FIM-FUNCOES--------------------------------------------------------|

case "$1" in
  -h | --help ) echo "Programa para gerar passwords com complexida alfanumérica e com caracteres especiais rapidamente via terminal"
               echo "Autor mateuscomh vulgo Django"
               exit 0 ;;
  -v | --version ) echo "Versão 1.2"
                  exit 0 ;;
 '') gerarsenha 
  ;;
  *) echo "$vermelho Opção inválida $fecha"
      exit 1 ;;
esac
