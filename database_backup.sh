#!/bin/bash

#-------------------------------------------------------------------------------
# Script simples de backup multiplo de banco de dados (mysql/mariadb)
# com envio de arquivo de backup por email
#
# O script envia um email de backup para cada base de dados do
# banco.
#
# versao 1.0
#
# *  Script deve ser executado na máquina onde roda o banco de dados
# 
# * Necessário um usuário no banco que tenha permissão de leitura em
# todas as bases que se deseja copiar. Usuário root não é recomendado.
#
#
# * Execute via cron adicionando uma linha semelhante ao exemplo a seguir:
#
#
# 00 00 * * *     /root/databasebackup/database_backup.sh
# 
#
# No exemplo acima o backup será executado todos os dias à meia-noite.
#
# Preencha o nome do usuário do banco (USER), a senha (PASS) bem como 
# o email (EMAIL) para onde sera enviado o backup.
#
# insira também o nome de cada base de dados no arquivo database.list (DBFILE)
#
# Script produzido por Rogerio da Costa (rogeriodacosta.com.br)
#
#-------------------------------------------------------------------------------


USER=usuario
PASS=senha
EMAIL=rogeriol@mpf.mp.br
BKPDIR=/tmp/dbbackup
DBFILE=database.list


#-----------------------------------------------------------------------
# Não faça alterações a patir deste ponto
#-----------------------------------------------------------------------


CHECKDBFILE=`ls $DBFILE | wc -l`
DB=`cat $DBFILE`
MAILTEXT=$BKPDIR/mailtext.txt

dbbkp(){
	mysqldump --user=$USER --password=$PASS $1 > $BKPDIR/$1.sql 2>> $MAILTEXT
}

send-email(){
	mail -s "Backup de base de dados - Banco - $1" -a $2 $EMAIL < $MAILTEXT
}



mkdir $BKPDIR 2> /dev/null

if [ $CHECKDBFILE -ne 0 ]; then

	for DATABASE in $DB; do

		rm -rf $BKPDIR/*
		DATA=`date +%d-%m-%Y-%H.%M`
		echo "" > $MAILTEXT
		echo "----------------------------------------------------" >> $MAILTEXT
		echo "Iniciando backup da base de dados $DATABASE em $DATA" >> $MAILTEXT
		echo "" >> $MAILTEXT

		#Realizando backup da base
		dbbkp $DATABASE
		DATA=`date +%d-%m-%Y-%H.%M`		
		echo "Backup da base de dados $DATABASE finalizado em $DATA" >> $MAILTEXT		
		echo "----------------------------------------------------" >> $MAILTEXT
		echo "Arquivo de backup em anexo" >> $MAILTEXT

		#Compactando arquivo
		tar -cvzf $BKPDIR/$DATABASE.tar.gz $BKPDIR/$DATABASE.sql
		
		#Enviando backup por email
		send-email $DATABASE $BKPDIR/$DATABASE.tar.gz

	done

else

	echo "" > $MAILTEXT
	echo "#########################" >> $MAILTEXT
	echo "#         ERRO          #" >> $MAILTEXT
	echo "#########################" >> $MAILTEXT
	echo "" >> $MAILTEXT
	echo "" >> $MAILTEXT
	echo "Arquivo com lista de bases de dados a serem backupeadas ($DBFILE) não existe" >> $MAILTEXT
	echo "" >> $MAILTEXT
	echo ""

	#enviando informaçao de erro por email
	mail -s "Backup de base de dados não realizado" $EMAIL < $MAILTEXT

fi

exit
