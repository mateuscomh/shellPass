#!/bin/bash

# Testando o caso de ajuda
output=$(bash shellPass.sh -h)
if [[ $output == *"Program to generate on shell random passwords"* ]]; then
  echo "Teste de ajuda passou."
else
  echo "Teste de ajuda falhou."
fi

# Testando a geração de senhas com apenas números
output=$(bash shellPass.sh 8 <<< "1")
if [[ $output =~ ^[0-9]{8}$ ]]; then
  echo "Teste de geração de senha com números passou."
else
  echo "Teste de geração de senha com números falhou."
fi

# Testando a geração de senhas com letras e números
output=$(bash shellPass.sh 12 <<< "2")
if [[ $output =~ ^[A-Za-z0-9]{12}$ ]]; then
  echo "Teste de geração de senha com letras e números passou."
else
  echo "Teste de geração de senha com letras e números falhou."
fi

# Testando a geração de senhas com letras, números e caracteres especiais
output=$(bash shellPass.sh 16 <<< "3")
if [[ $output =~ ^[A-Za-z0-9!"#$%&'()*+,-./:;<=>?@[\]^_{|}~]{16}$ ]]; then
  echo "Teste de geração de senha com letras, números e caracteres especiais passou."
else
  echo "Teste de geração de senha com letras, números e caracteres especiais falhou."
fi
