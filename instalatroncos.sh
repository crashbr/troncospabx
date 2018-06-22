#!/bin/bash

#Inicia cópia de arquivos para os diretórios corretos
cp troncos.service /usr/lib/systemd/system/
chmod +x troncos.sh
mkdir /Scripts
mv troncos.sh /Scripts

#Ativa inicialização automática do serviço
systemctl daemon-reload
systemctl enable troncos.service
systemctl start troncos.service

