use pruebas
go
/*
procedure para montar los totales del resumen en una tabla 
exemplo: exec spResumenEjecutivo 'CLCH','2019/01/01' ,'2019/01/31'
*/
create procedure spResumenEjecutivo 
--declare  -->COMENTAR O DESCOMENTAR PARA PROBAR O ALTERAR---
	@oficina varchar(100)='CLCH',-->aqui puedes poner un valor default
	@fechaIni smalldatetime = '2019/03/01', -->aqui puedes poner un valor default
	@fechaFin smalldatetime = '' -->aqui puedes poner un valor default
as 
	--> no mostrar el mensaje: n "row(s) affected" 
	set nocount on
	--> confifurar el formato de las fechas
	set dateformat ymd

	declare @diaPrimero smalldatetime = convert(varchar(4),year(getdate())) + '/01/01'

	-->si no especifica a @fecha principal entonces @fechaIni primer dia del año actual
	if isnull(@fechaIni,'')='' select @fechaIni=left(convert(varchar,getdate(),111),8)+'01' 
	if isnull(@fechaFin,'')='' select @fechaFin=getdate()

	-->retirar la hora delas @fechas
	select @fechaIni=convert(varchar,@fechaIni,111)
	select @fechaFin=convert(varchar,@fechaFin,111)
	--select @oficina as '@oficina',@fechaIni as '@fechaIni',@fechaFin as '@fechaFin'--@

	-->variables para saber el año actual y anterior
	declare @anioActual varchar(4)=convert(varchar(4),year(getdate())),
			@anioAnterior varchar(4)=convert(varchar(4),year(getdate())-1)

	-->variables para saber el dia primero y ultimo
	declare @diaPrimeroMes smalldatetime =  left(convert(varchar,@fechaIni,111),8)+'01' ,
			@diaUltimoMes smalldatetime = dateadd(day,-1,left(convert(varchar,dateadd(month,1,@fechaIni),111),8)+'01')

	-->ejemplos para calcular las fechas, nuevas varaibles pueden ser declaradas caso necesario
	--@
	/*select	
			@oficina as '@oficina',
			@fechaIni as '@fechaIni',
			@fechaFin as '@fechaFin',
			@anioActual as '@anioActual',
			@anioAnterior as '@anioAnterior',
			@diaPrimero as '@diaPrimero AÑO (fecha ini)',
			@diaPrimeroMes as '@diaPrimeroMes', 
			@diaUltimoMes as '@diaUltimoMes',
			dateadd(month,-1,@diaPrimeroMes) as '@diaPrimeroMes ANTERIOR (fecha ini)',  
			dateadd(year,-1,@diaPrimeroMes) as '@diaPrimeroMes AÑO ANTERIOR', 
			dateadd(year,-1,@diaUltimoMes) as '@diaUltimoMes AO ANTERIOR',
			(select * from dbo.fnNombreMes(@diaPrimeroMes)) AS 'MES ACTUAL',
			(select * from dbo.fnNombreMes(dateadd(day,-1,@diaPrimeroMes))) AS 'MES ANTERIOR'*/
		--@	
	


	-->variable para retornar el resultado
	declare @retorno as table	(
		Id int identity not null,
		Concepto varchar(100),
		Actual varchar(100),
		Anterior varchar(100)
	)

	-->variables para almacenar los calculos por concepto
	declare @Concepto varchar(100)='',
			@Actual   varchar(100)='',
			@Anterior varchar(100)='',
			@valorActual   money,
			@valorAnterior money


	--Obtener, formatar e insertar valores linea1
	select @Concepto = 'Ventas del mes.'
	select @valorActual=(select * from dbo.fnResumenVentas(@oficina,@diaPrimeroMes,@diaUltimoMes))
	select @ValorAnterior= (select * from dbo.fnResumenVentas(@oficina,dateadd(year,-1,@diaPrimeroMes), dateadd(year,-1,@diaUltimoMes)))
	select @Actual   = case when @valorActual	 is null then 'NA' else  '$'+convert(varchar,convert(money,isnull(@valorActual,0)),1) end
	select @Anterior = case when @valorAnterior	 is null then 'NA' else  '$'+convert(varchar,convert(money,isnull(@valorAnterior,0)),1) end
	insert into @retorno select @Concepto,@Actual,@Anterior

	--Obtener, formatar e insertar valores linea2
	select @Concepto = 'Ventas del año.'
	select @valorActual=(select * from dbo.fnResumenVentas(@oficina,@diaPrimero,getdate()))
	select @ValorAnterior= (select * from dbo.fnResumenVentas(@oficina,dateadd(year,-1,@diaPrimero),dateadd(year,-1,getdate())))
	select @Actual   = case when @valorActual	 is null then 'NA' else  '$'+convert(varchar,convert(money,isnull(@valorActual,0)),1) end
	select @Anterior = case when @valorAnterior	 is null then 'NA' else  '$'+convert(varchar,convert(money,isnull(@valorAnterior,0)),1) end
	insert into @retorno select @Concepto,@Actual,@Anterior
	
	--Obtener, formatar e insertar valores linea3
	select @Concepto = 'Cobranza del mes.'
	select @valorActual=(select * from dbo.fnResumenCobranza(@oficina,@diaPrimeroMes,@diaUltimoMes))
	select @ValorAnterior=(select * from dbo.fnResumenCobranza(@oficina,dateadd(year,-1,@diaPrimeroMes), dateadd(year,-1,@diaUltimoMes)))
	select @Actual   = case when @valorActual	 is null then 'NA' else  '$'+convert(varchar,convert(money,isnull(@valorActual,0)),1) end
	select @Anterior = case when @valorAnterior	 is null then 'NA' else  '$'+convert(varchar,convert(money,isnull(@valorAnterior,0)),1) end
	insert into @retorno select @Concepto,@Actual,@Anterior

	--Obtener, formatar e insertar valores linea4
	select @Concepto = 'Cuentas por cobrar al ' + convert(varchar,day(@diaUltimoMes)) + ' de ' + lower((select * from dbo.fnNombreMes(@diaPrimeroMes))) + '.'
	select @valorActual=(select * from dbo.fnResumenCobranza(@oficina,@diaPrimero,dateadd(month,-1,@diaPrimeroMes)))  
	select @ValorAnterior=null
	select @Actual   = case when @valorActual	 is null then 'NA' else  '$'+convert(varchar,convert(money,isnull(@valorActual,0)),1) end
	select @Anterior = case when @valorAnterior	 is null then 'NA' else  '$'+convert(varchar,convert(money,isnull(@valorAnterior,0)),1) end
	insert into @retorno select @Concepto,@Actual,@Anterior

	--Obtener, formatar e insertar valores linea5
	select @Concepto = 'Cuentas por cobrar con más de 180 días al ' + convert(varchar,day(dateadd(day,-1,@diaPrimeroMes))) + ' de ' + (select * from dbo.fnNombreMes(dateadd(day,-1,@diaPrimeroMes))) +'.'
	select @valorActual=(select * from dbo.fnResumenCuentasPorCobrar(@oficina,@diaPrimero,dateadd(month,-1,@diaPrimeroMes)))  
	select @ValorAnterior=null
	select @Actual   = case when @valorActual	 is null then 'NA' else  '$'+convert(varchar,convert(money,isnull(@valorActual,0)),1) end
	select @Anterior = case when @valorAnterior	 is null then 'NA' else  '$'+convert(varchar,convert(money,isnull(@valorAnterior,0)),1) end
	insert into @retorno select @Concepto,@Actual,@Anterior

	
	-->retornar el resultado final
	select 
		Concepto, 
		Actual,
		Anterior
	from @retorno 
	order by id

/*FIN*/

