-->variables para fechas
declare @fechaIni varchar(10) = left(convert(varchar,getdate(),111),8)+'01' 
declare @fehcaFin varchar(10) = convert(varchar,getdate(),111)
select @fechaIni as 'fechaIni',@fehcaFin as 'fechaFin'

-->variable para script de sql
declare @sql nvarchar(max)

-->variable para las oficinas
declare @oficinas as table(
	Oficina varchar(8),
	Nombre varchar(100),
	Destinatarios varchar(max)
)

-->insertar en la variable las oficinas para enviar email
	insert into @oficinas--
	select 	'000'+convert(varchar,database_id) as Oficina, name as Nombre, name+'@mail.com' as Destinatarios from sys.databases where database_id<5
	--select Oficina,Nombre,Destinatarios from ResumenEjecutivo where Activo=1 order by  Oficina

-->apenas para confirmar
select * from @oficinas

-->montar o script para llamar el sp de envio de emails
declare @script nvarchar(max) = N''
select @script += 'EXEC spResumenExecutivoEMAIL ''' +  oficina +''','''+ @fechaIni +''',''' + @fehcaFin +''','''+ Destinatarios + '''' + char(10)
		from @oficinas

print @script
select @script
--descomentar el EXEC para executar
--EXEC (@script)
