use pruebas
go
/*
Procedure para enviar email (s)
ejemplo: 
exec spResumenEjecutivoEMAIL 'CLCH','2019/01/01' ,'2019/01/31','nombre@mail.com;otro@mail.com'
exec spResumenEjecutivoEMAIL 'CDMX','2019/01/01' ,'2019/01/31','usuario@mail.com'
...
*/
create procedure spResumenEjecutivoEMAIL
--declare  -->COMENTAR O DESCOMENTAR PARA PROBAR O ALTERAR---
	@oficina varchar(100)='CLCH',-->aqui puedes poner un valor default
	@fechaIni smalldatetime = '2019/03/01', -->aqui puedes poner un valor default
	@fechaFin smalldatetime = '', -->aqui puedes poner un valor default
	@destinatario nvarchar(max)='' --nombre1@mail.com;nombre2@mail.com...
as 
	set nocount on

	declare @resumen nvarchar(max)
	exec spResumenEjecutivoHTML 'CLCH','2019/03/01','', @resumen output
	--select @resumen

	declare @asunto varchar(max)= 'Resumen Ejecutivo ' + @oficina ,
			@cuerpo nvarchar(max)=@resumen,
			@adjunto varchar(max) = ''--'C:\carpeta\archivo.ext' --las unidades y carpetas son en relacion a donde est� instalado el sql

	select 'descomentar esto cuando el dbmail sea configurado ' + @resumen
	/*
	--> si tiene anexo
	if isnull(@adjunto,'')<>''
		EXEC msdb.dbo.sp_send_dbmail 
			@profile_name = 'PerfilDBmail',
			@recipients = @destinatario,
			@subject = @asunto,
			@body = @cuerpo,
			@body_format = 'HTML', --TEXT
			@file_attachments=@adjunto
	else--> si no tiene anexo
			EXEC msdb.dbo.sp_send_dbmail 
			@profile_name = 'PerfilDBmail',
			@recipients = @destinatario,
			@subject = @asunto,
			@body = @cuerpo,
			@body_format = 'HTML' --TEXT
	*/
		
/*FIN*/
