use pruebas
go
/*
procedure para generar el HTML del resumen basado en spResumenEjecutivo
ejemplo: exec spResumenEjecutivoHTML 'CLCH','2019/01/01' ,'2019/01/31'
*/
create procedure spResumenEjecutivoHTML
--declare  -->COMENTAR O DESCOMENTAR PARA PROBAR O ALTERAR---
	@oficina varchar(100)='CLCH',-->aqui puedes poner un valor default
	@fechaIni smalldatetime = '2019/03/01', -->aqui puedes poner un valor default
	@fechaFin smalldatetime = '', -->aqui puedes poner un valor default
	@resumen nvarchar(max)='' OUTPUT

as 
set nocount on

	-->si no especifica a @fecha principal entonces @fechaIni primer dia del año actual
	if isnull(@fechaIni,'')='' select @fechaIni=left(convert(varchar,getdate(),111),8)+'01' 
	if isnull(@fechaFin,'')='' select @fechaFin=getdate()

	declare @retorno as table	(
		Concepto varchar(100),
		Actual varchar(100),
		Anterior varchar(100)
	)

	insert into @retorno
	exec spResumenEjecutivo @oficina,@fechaIni,@fechaFin

	--select  * from  @resultado--@

	declare @lineas nvarchar(max)=N'',
			@html nvarchar(max)=N'',
			@css nvarchar(max)=N''


	select @lineas = @lineas +
		'
		<tr>
			<td style="font-weight: bold;">'+ Concepto +'</td>
			<td style="text-align: right;">'+ Actual   +'</td>
			<td style="text-align: right;">'+ Anterior +'</td>
		</tr>
		'
	from @retorno
				


	-->definir estilo y formatos CSS
	select  @css=N'
	<!DOCTYPE html>
	<meta charset="utf-8" />
    <style type="text/css">
        .tg  {border-collapse:collapse;border-spacing:0;border-color:#000099;}
        .tg th{font-family:Arial, sans-serif;font-size:16px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#000066;color:#fff;background-color:#000099;}
        .tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#000066;color:#000;}
        tr:nth-child(odd) td{background-color:#fff} /*color alternado pares*/
        tr:nth-child(even) td{background-color:#d2e4fc} /*color alternado impares*/
		.texto{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;}
	</style>
	'
	-->montar HMTL
	select @html=N'
    <p class="texto">
        Estimado Socio,
        <br>
        <br>
        A continuación se presenta Resumen Ejecutivo de la oficina bajo su responsabilidad, se adjuntan archivos con el detalle.
    </p>        
    <table class="tg";table-layout: fixed; width: 720px>
        <colgroup>
            <col style="width: 300">
            <col style="width: 210">
            <col style="width: 210">
        </colgroup>
        <tr>
            <th>Concepto - @oficina@</th>
            <th>Actual (@actual@)</th>
            <th>Anterior [@anterior@]</th>
        </tr>

		  @lineas@

	</table>
    <p class="texto">
        Para cualquier aclaración o comentario por favor comunicarse a la ODE.
    </p>        
	'
	-->reemplazar parametros
	select @html = REPLACE(@html,'@oficina@',@oficina)
	select @html = REPLACE(@html,'@actual@',year(@fechaIni))
	select @html = REPLACE(@html,'@anterior@',year(@fechaIni)-1)
	-->reemplazar @lineas@ con los datos formatados
	select @html = REPLACE(@html,'@lineas@',@lineas)

	select @resumen=@css + @html
	--print @resumen --@
	select  @resumen as retorno
	

