use pruebas
go
/*
ejemplo: select * from dbo.fnResumenCuentasPorCobrar('','','')
*/

create function dbo.fnResumenCuentasPorCobrar(
--declare -->COMENTAR O DESCOMENTAR PARA PROBAR O ALTERAR---
	@oficina varchar(100)='CLCH',-->aqui puedes poner un valor default
	@fechaIni smalldatetime = '2019/03/01', -->aqui puedes poner un valor default
	@fechaFin smalldatetime = '' -->aqui puedes poner un valor default
) returns table as return

--> esta linea es apenas para simular un resultado al final comentar e colocar la consulta correcta que retorne apenas un valor
select (convert(money,datepart(ms,getdate())/99.01))  as [retorno] --@
/*
colocar aqui la consulta que retorna el resultado
*/