use pruebas
go
/*
ejemplo: select * from dbo.fnResumenVentas('','','')
*/
create function dbo.fnResumenVentas(
--declare -->COMENTAR O DESCOMENTAR PARA PROBAR O ALTERAR---
	@oficina varchar(100)='CLCH',-->aqui puedes poner un valor default
	@fechaIni smalldatetime = '2019/03/01', -->aqui puedes poner un valor default
	@fechaFin smalldatetime = '' -->aqui puedes poner un valor default
) returns table as return

--> esta linea es apenas para simular un resultado al final comentar e colocar la consulta correcta que retorne apenas un valor
select (convert(money,datepart(ms,getdate())/100.01) + convert(money,@fechaIni)/datepart(ms,getdate())) as [retorno] --@
--!!! esta funcion podria calular mensualmente o anualmente dependiendo de los parametros
/*
select sum(SubTotal) as [retorno]-- retorna la suma de los subtotales
from (
	SELECT
	sum (CASE T0.CANCELED WHEN 'C' THEN (T0.doctotal - T0.vatsum)*-1 ELSE (T0.doctotal - T0.vatsum) END) AS 'Subtotal'
	FROM      OINV T0
	WHERE     T0.CardCode LIKE @OFICINA+'%' AND T0.DocDate BETWEEN @FECHAINI and @FECHAFIN
	union 

	SELECT CAST(RAND(CHECKSUM(NEWID())) * 9 as INT) + 1 as 'Subtotal' 
	sum (CASE T0.CANCELED WHEN 'C' THEN (T0.doctotal - T0.vatsum) ELSE (T0.doctotal - T0.vatsum)*-1 END) AS 'Subtotal'
	FROM      ORIN T0
	WHERE     T0.CardCode LIKE @OFICINA+'%' AND T0.DocDate BETWEEN @FECHAINI and @FECHAFIN
) as ventas
*/
