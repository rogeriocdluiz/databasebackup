# Databasebackup
Backup script to Mysql/Mariadb databases.

Script de backup múltiplo de banco de dados (mysql/mariadb) com envio de arquivo de backup por email

O script envia um email de backup para cada base de dados do banco.

# Observações

 *  Script deve ser executado na máquina onde roda o banco de dados
 
 * Necessário um usuário no banco que tenha permissão de leitura em todas as bases que se deseja copiar. Usuário root não é recomendado.

 * Execute via cron adicionando uma linha semelhante ao exemplo a seguir:


 00 00 * * *     /root/databasebackup/database_backup.sh

 No exemplo acima o backup será executado todos os dias à meia-noite.

 Preencha o nome do usuário do banco (USER), a senha (PASS) bem como o email (EMAIL) para onde sera enviado o backup.
 insira também o nome de cada base de dados no arquivo database.list (DBFILE)
