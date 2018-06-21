#!/bin/bash

# Função para verificar se o tronco esta com algum problema.
verificatronco() {
asterisk -rx "sip show registry" | grep "$1" >> /dev/null
}

#Tenta recarregar os troncos
recarregatronco() {
asterisk -rx "sip reload"
}

# Função para verificar qual a operadora que esta com problema.
verificaoperadora () {
asterisk -rx "sip show registry" | grep "$1" | cut -d ' ' -f1 | cut -d "." -f2
}
# Função para enviar e-mail
enviamail () {

DATA=`date +%Y-%m-%d`
HORA=`date +%H:%M:%S`

SUBJECT="Verificar troncos no $HOSTNAME"
RECEIVER="email@destinatario.com.br"
TEXT="Tronco $OP esta sem registro $DATA $HORA"

SENDER=$(whoami)
USER="noreply"

MAIL_TXT="Subject: $SUBJECT\nFrom: $SENDER\nTo: $RECEIVER\n\n$TEXT"

echo -e $MAIL_TXT | sendmail -t
echo `date` >> /tmp/troncos.log
}

#Variáveis com erros conhecidos no Asterisk/Issabel

ERRO1="No Authentication"
ERRO2="Unregistered"
ERRO3="Request Sent"
ERRO4="Auth. Sent"

# Laço para rodar o script em daemon

while true
do
        touch /tmp/troncos.log
        verificatronco $ERRO1
        if [ $? == 0 ]
        then
                OP=$(verificaoperadora $ERRO1)
                enviamail
                recarregatronco
                sleep 5
        fi
        verificatronco $ERRO2
        if [ $? == 0 ]
        then
                OP=$(verificaoperadora $ERRO2)
                enviamail
                recarregatronco
                sleep 5
        fi
        verificatronco $ERRO3
        if [ $? == 0 ]
        then
                OP=$(verificaoperadora $ERRO3)
                enviamail
                recarregatronco
                sleep 5
        fi
        verificatronco $ERRO4
        if [ $? == 0 ]
        then
                OP=$(verificaoperadora $ERRO4)
                enviamail
                recarregatronco
                sleep 5
        fi
        URGENTE=$(cat /tmp/troncos.log | wc -l)
        if [ $URGENTE -ge  5 ]
        then
        echo "Verificar com urgência "$HOSTNAME"" | mail -s "URGENTE" email@email.com.br
        rm -rf /tmp/troncos.log
        fi
sleep 300
done
