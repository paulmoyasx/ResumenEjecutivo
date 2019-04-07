use pruebas
go
/*
ejemplo: select * from dbo.fnResumenCobranza('','','')
*/

create function dbo.fnResumenCobranza(
--declare -->COMENTAR O DESCOMENTAR PARA PROBAR O ALTERAR---
	@oficina varchar(100)='CLCH',-->aqui puedes poner un valor default
	@fechaIni smalldatetime = '2019/03/01', -->aqui puedes poner un valor default
	@fechaFin smalldatetime = '' -->aqui puedes poner un valor default
) returns table as return

--> esta linea es apenas para simular un resultado al final comentar e colocar la consulta correcta que retorne apenas un valor
select (convert(money,datepart(ms,getdate())/200.01) + convert(money,@fechaIni)/datepart(ms,getdate()))*-1 as [retorno] --@
--!!! esta funcion podria calular mensualmente o anualmente dependiendo de los parametros
/*
SELECT  

					  sum(CASE WHEN DATEDIFF(DAY, T1.RefDate, @FECHAFIN) > 180 AND T3.DebHab = 'D' THEN T1.Debit - T1.Credit - T3.ReconSum WHEN DATEDIFF(DAY, T1.RefDate, @FECHAFIN) > 180 AND 
                      T3.DebHab = 'C' THEN T1.Debit - T1.Credit + T3.ReconSum WHEN DATEDIFF(DAY, T1.RefDate, @FECHAFIN) > 180 THEN (T1.Debit - T1.Credit) END) AS [+181 días]

FROM         dbo.OCRD AS T0 INNER JOIN
                      dbo.JDT1 AS T1 ON T1.ShortName = T0.CardCode INNER JOIN
                      dbo.OACT AS T2 ON T2.AcctCode = T1.Account INNER JOIN
                      dbo.OJDT AS T4 ON T4.TransId = T1.TransId LEFT OUTER JOIN
                      dbo.OINV AS Y1 ON Y1.TransId = T1.TransId LEFT OUTER JOIN
                      dbo.ORIN AS Y2 ON Y2.TransId = T1.TransId LEFT OUTER JOIN
                      dbo.OSLP AS Y3 ON Y3.SlpCode = Y1.SlpCode OR Y3.SlpCode = Y2.SlpCode LEFT OUTER JOIN
					  dbo.[@BXP_GERENTES]  AS Y4 on Y4.Code = Y1.U_BXP_GERENTE OR Y4.Code = Y2.U_BXP_GERENTE LEFT OUTER JOIN
					  dbo.[@BXP_ASOCIADOS]  AS Y5 on Y5.Code = Y1.U_BXP_ASOCIADOS OR Y4.Code = Y2.U_BXP_ASOCIADOS LEFT OUTER JOIN
                          (SELECT     X0.ShortName AS 'SN', X0.TransId, SUM(X0.ReconSum) AS 'ReconSum', X0.IsCredit AS 'DebHab', X0.TransRowId AS 'Linea'
                            FROM          dbo.ITR1 AS X0 INNER JOIN
                                                   dbo.OITR AS X1 ON X1.ReconNum = X0.ReconNum
                            WHERE      (X1.ReconDate <= @FECHAFIN) AND (X1.CancelAbs = '')
                            GROUP BY X0.ShortName, X0.TransId, X0.IsCredit, X0.TransRowId) AS T3 ON T3.TransId = T1.TransId AND T3.SN = T1.ShortName AND 
                      T3.Linea = T1.Line_ID
WHERE     (T0.CardType = 'C') AND (T1.RefDate <= @FECHAFIN) AND ((CASE WHEN T3.DebHab = 'D' THEN (T1.Debit - T1.Credit - T3.ReconSum) 
                      WHEN T3.DebHab = 'C' THEN (T1.Debit - T1.Credit + T3.ReconSum) ELSE (T1.Debit - T1.Credit) END) <> '0') --AND T0.CardCode like 'CLOM%' OR
					  AND T0.CardCode like @OFICINA+'%'
					  --order by t0.CardCode	) as ventas
*/
