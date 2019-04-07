use pruebas
go

USE [master]
GO 
EXEC xp_servicecontrol 'QueryState', 'SQLServerAGENT';
GO
-- Habiliar opciones avanzadas de configuracion
USE [master]
GO
EXEC sp_configure 'show advanced options', 1;
GO 
RECONFIGURE;
GO
-- Habiliar Database Mail XPs
 
EXEC sp_configure 'Database Mail XPs', 1;
GO
 
RECONFIGURE;
GO

-- Crear una cuenta de Database Mail
EXEC msdb.dbo.sysmail_add_account_sp
@account_name = 'CuentaGmail', -- Nombre de la cuenta
@description = 'Cuenta de Gmail', -- Descripcion de la cuenta
@email_address = '???@gmail.com', -- Direccion del remitente
@display_name = '???', -- Nombre para mostrar e-mail
@replyto_address = '????@gmail.com', -- Responder para
@mailserver_type = 'SMTP', -- Tipo de envio
@mailserver_name = 'smtp.gmail.com', -- Direccion de servidor de e-mail
@port = 587, -- Puerta de envio
@use_default_credentials = 0, -- 0 para conexion no segura y 1 para conexion segura
@username = '???@gmail.com', -- E-mail para autenticarse
@password = '***'; -- password
GO
-- Cria un perfil
EXEC msdb.dbo.sysmail_add_profile_sp
@profile_name = 'PerfilDBmail', -- Nombre del perfil
@description = 'Perfil DB Mail'; -- Desripcion del perfil
GO

-- Adicionar una cuenta al perfil
EXEC msdb.dbo.sysmail_add_profileaccount_sp
@profile_name = 'PerfilDBmail', -- Nombre del perfil
@account_name = 'CuentaGmail', -- Nombre de la cuenta
@sequence_number = 1; -- N�mero sequencial para determinar a ordem em que as contas de e-mail podem ser utilizadas
GO

--caso necessario crear el usuario del login en msdb
USE [msdb]
GO
CREATE USER [usuario] FOR LOGIN [usuario]
GO
--agregar el usuario al rol de dbmail
USE [msdb]
GO
ALTER ROLE [DatabaseMailUserRole] ADD MEMBER [usuario]
GO

-- verificar  si el service broker esta habilitado
USE master
GO
SELECT is_broker_enabled FROM sys.databases WHERE name = 'msdb'

--consultar status ddel dbmail
EXEC msdb.dbo.sysmail_help_status_sp
EXEC msdb.dbo.sysmail_help_queue_sp @queue_type = 'mail'

--iniciar el servicio dbmail caso necessario
--EXEC msdb.dbo.sysmail_start_sp

--parar dbmail caso necesario
--EXEC msdb.dbo.sysmail_stop_sp 
GO  

--consultar registros en el log del dbmail
select * from msdb.dbo.sysmail_allitems
select * from msdb.dbo.sysmail_sentitems
select * from msdb.dbo.sysmail_unsentitems
select * from msdb.dbo.sysmail_faileditems