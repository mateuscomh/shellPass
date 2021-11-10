#!/usr/bin/env bash

#-----------HEADER-------------------------------------------------------------|
# AUTOR             : Matheus Martins 3mhenrique@gmail.com
# HOMEPAGE          : https://github.com/mateuscomh 
# DATA CRIAÇÃO      : 29/08/2020 
# PROGRAMA          : Shell-Base
# VERSÃO            : 1.7.1
# LICENÇA           : GPL3
# PEQUENA-DESCRICÃO : Programa para criar senhas seguras via terminal
#                   - Utilizar desenvolvido em shell: user SH para execucao com cores

#----------FIM-HEADER---------------------------------------------------------|
fecha='\033[m'
verde='\033[32;1m'
vermelho='\033[31;1m'
amarelo='\033[01;33m'

#----------FUNCOES------------------------------------------------------------|
max=$1
_gerarsenha(){
if [ -z "$max" ] || [ "$max" -eq 0 ]; then
  echo -e "${verde} Informe a QUANTIDADE de caracteres para a ser gerada: ${fecha}"
  read -r max
fi

case $max in
  ''|*[!0-9]*) 
    echo -e "${vermelho} Insira apenas números referente ao TAMANHO da senha a ser gerada ${fecha}" >&2
    return 1 
    ;;
  [0-9]*) echo -e "${verde} Informe o TIPO da complexidade de senha que deseja: ${fecha}
  ${amarelo} 1 - Senha apenas números ${fecha}
  ${amarelo} 2 - Senha com LeTrAs e números ${fecha}
  ${amarelo} 3 - Senha com LeTrAs, números e caracteres especiais ${fecha}"
read -r tipo
  
  case "$tipo" in
    ''|*[!0-9]*) 
      echo -e "${vermelho} Insira apenas números referente ao TIPO da senha a ser gerada ${fecha}" >&2
      return 2
      ;;
    1)
      echo -e "${vermelho} Senha gerada: ${amarelo}"
      </dev/urandom LC_ALL=C tr -dc '0-9' | head -c "$max"  ; echo -e "${fecha}"
      ;;
    2)
      echo -e "${vermelho} Senha gerada: ${amarelo}"
      </dev/urandom LC_ALL=C tr -dc 'A-Za-z0-9' | head -c "$max"  ; echo -e "${fecha}" ;;
		3)
      echo -e "${vermelho} Senha gerada: ${amarelo}"
      </dev/urandom LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c "$max"
      echo -e "${fecha}" 
      ;;
    *)
      echo -e "${vermelho} Utilizar as opcoes [4,2,3] ${fecha}"
      return 1 
      ;;
  esac
esac
}
#----------FIM-FUNCOES--------------------------------------------------------|

case "$max" in
  -h | --help ) 
    echo -e "${verde} Programa para gerar passwords com complexidade
    alfanumérica e com caracteres especiais rapidamente via terminal ${fecha}"
    echo -e "${verde} Autor mateuscomh vulgo Django ${fecha}"
    exit 0 
    ;;
  -v | --version ) 
    echo -e "${verde} Versão 1.7 ${fecha}"
    exit 0 ;;
  '') 
    OP=s
    while true; do
      if [[ "$OP" = [sS] ]]; then
        max=0
      _gerarsenha
        read -n 1 -p "Deseja gerar nova senha? [s/n]" OP; echo
      elif [[ "$OP" = [nN] ]]; then
        break
      else 
        echo -e "${vermelho} Opção inválida ${fecha}"
        read -n 1 -p "Deseja gerar nova senha? [s/n]" OP; echo
      fi
    done ;;
  [0-9]*)
    _gerarsenha
#  *) echo -e "${vermelho} Não é necessário parâmetro inicial ${fecha}"
#    exit 2;;
esac
