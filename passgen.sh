#!/usr/bin/env bash

#-----------HEADER-------------------------------------------------------------|
# AUTOR             : Matheus Martins 3mhenrique@gmail.com
# HOMEPAGE          : https://github.com/mateuscomh 
# DATA CRIAÇÃO      : 29/08/2020 
# PROGRAMA          : Shell-Base
# VERSÃO            : 1.6
# LICENÇA           : GPL3
# PEQUENA-DESCRICÃO : Programa para criar senhas seguras via terminal
#                   - Utilizar desenvolvido em shell: user SH para execucao com cores
#
# CHANGELOG :
# 29/08/2020 18:00 - Adicionada validaçãoo de apenas número a ser recebido pelo usuário
#                  - Adicionado cabeçalho para commit no git
# 30/08/2020 13:00 - Adicionado status de help e versao
# 09/09/2021 10:00 - Implementado recurso de escolha de tipos de senha
#                  - Atualizado no repositorio GIT e renomeado para fácil acesso
# 12/10/2021 18:00 - Adicionado looping de novas senhas
# 13/10/2021 19:00 - Alterado código para funcionamento em bash
#
#----------FIM-HEADER---------------------------------------------------------|
fecha='\033[m'
verde='\033[32;1m'
vermelho='\033[31;1m'
amarelo='\033[01;33m'

#----------FUNCOES------------------------------------------------------------|
_gerarsenha(){

echo -e "${verde} Informe a QUANTIDADE de caracteres para a ser gerada: ${fecha}"
read -r max

case $max in
  ''|*[!0-9]*) echo -e "${vermelho} Insira apenas números referente ao TAMANHO da senha a ser gerada ${fecha}" >&2
  exit 1;;
  [0-9]*) echo -e "${verde} Informe o TIPO da complexidade de senha que deseja: ${fecha}
${amarelo} 1 - Senha apenas números ${fecha}
${amarelo} 2 - Senha com LeTrAs e números ${fecha}
${amarelo} 3 - Senha com LeTrAs, números e caracteres especiais ${fecha}"
read -r tipo
	case "$tipo" in
		''|*[!0-9]*) echo -e "${vermelho} Insira apenas números referente ao TIPO da senha a ser gerada ${fecha}" >&2
		exit 1;;
		1) echo -e "${vermelho} Senha gerada: ${amarelo}"
			</dev/urandom tr -dc '0-9' | head -c "$max"  ; echo -e "${fecha}"
			;;
		2) echo -e "${vermelho} Senha gerada: ${amarelo}"
			</dev/urandom tr -dc 'A-Za-z0-9' | head -c "$max"  ; echo -e "${fecha}" ;;
		3) echo -e "${vermelho} Senha gerada: ${amarelo}"
			</dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c "$max" ; echo -e "${fecha}" ;;
        *) echo -e "${vermelho} Utilizar as opcoes [1,2,3] ${fecha}" ;;
	esac
esac
}
#----------FIM-FUNCOES--------------------------------------------------------|

case "$1" in
  -h | --help ) echo -e "${verde} Programa para gerar passwords com complexidade
    alfanumérica e com caracteres especiais rapidamente via terminal ${fecha}"
               echo -e "${verde} Autor mateuscomh vulgo Django ${fecha}"
               exit 0 ;;
  -v | --version ) echo -e "${verde} Versão 1.6 ${fecha}"
                  exit 0 ;;
 '') OP=s
   while true; do
    if [[ "$OP" = [sS] ]]; then
      _gerarsenha
        read -p "Deseja gerar nova senha? [s/n]" OP; 
     elif [[ "$OP" = [nN] ]]; then
       break
     else 
       echo -e "${vermelho} Opção inválida ${fecha}"
        read -n 1 -p "Deseja gerar nova senha? [s/n]" OP; echo
      fi
    done ;;
  *) echo -e "${vermelho} Não é necessário parâmetro inicial ${fecha}"
     exit 1;;
esac
