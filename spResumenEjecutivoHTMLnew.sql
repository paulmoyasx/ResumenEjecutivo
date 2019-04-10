use pruebas
go
--create procedure spResumenEjecutivoHTMLnew
declare  -->COMENTAR O DESCOMENTAR PARA PROBAR O ALTERAR---
	@oficina varchar(100)='CLCH',-->aqui puedes poner un valor default
	@fechaIni smalldatetime = '2019/03/01', -->aqui puedes poner un valor default
	@fechaFin smalldatetime = '2019/03/31', -->aqui puedes poner un valor default
	@resumen nvarchar(max)='' --OUTPUT
--as 
set nocount on

	-->si no especifica a @fecha principal entonces @fechaIni primer dia del año actual
	if isnull(@fechaIni,'')='' select @fechaIni=left(convert(varchar,getdate(),111),8)+'01' 
	if isnull(@fechaFin,'')='' select @fechaFin=getdate()

	-->variable para tratar el resumen
    declare @retorno as table	(
        id int IDENTITY(1,1) not null,
		Concepto varchar(100),
		Actual varchar(100),
		Anterior varchar(100)
	)

    -->insertar en la variable el retorno del procedure
	insert into @retorno 
	exec spResumenEjecutivo @oficina,@fechaIni,@fechaFin

	--select  * from  @retorno--@

	declare @lineas nvarchar(max)=N'',
			@html nvarchar(max)=N'',
			@css nvarchar(max)=N'',            
            @PARES nvarchar(max)   ='style="background-color:#ffffff;"',--estilo para lineas pares
            @IMPARES nvarchar(max) ='style="background-color:#d2e4fc;"',--estilo para lineas impares
            @TITULOS nvarchar(max) ='style="background-color:#3166ff;"' --estilo para linea de titulos

	select @lineas = @lineas +
		'
		<tr ' + case when id%2=0 then '@PARES@' else '@IMPARES@' end + ' >
			<td style="font-weight: bold;">'+ Concepto +'</td>
			<td style="text-align: right;">'+ Actual   +'</td>
			<td style="text-align: right;">'+ Anterior +'</td>
		</tr>
		'
	from @retorno
				


	-->definir estilo y formatos CSS
	select  @css=N'
	
	<meta charset="utf-8"/>
    <style type="text/css">
        .tg  {border-collapse:collapse;border-spacing:0;border-color:#000099;}
        .tg th{font-family:Arial, sans-serif;font-size:16px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#000066;color:#fff;}
        .tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#000066;color:#000;}
        /*tr:nth-child(odd) td{background-color:#fff}*/ /*color alternado pares*/
        /*tr:nth-child(even) td{background-color:#d2e4fc}*/ /*color alternado impares*/
		.texto{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;}
	</style>
	'
	-->montar HMTL
	select @html=N'
    <p class="texto">
        Estimado Socio,
        <br>
        <br>
        A continuación se presenta Resumen Ejecutivo de la oficina <strong>@OFICINA@</strong> bajo su responsabilidad, se adjuntan archivos con el detalle.
    </p>        
    <table class="tg";table-layout: fixed; width: 720px>
        <colgroup>
            <col style="width: 300">
            <col style="width: 210">
            <col style="width: 210">
        </colgroup>
        <tr @TITULOS@>
            <th>Concepto - @OFICINA@ </th>
            <th>Actual (@ACTUAL@)</th>
            <th>Anterior [@ANTERIOR@]</th>
        </tr>

		  @LINEAS@

	</table>
    <p class="texto">
        Para cualquier aclaración o comentario por favor comunicarse a la ODE. 
    </p>        
	'
	-->reemplazar parametros
	select @html = REPLACE(@html,'@OFICINA@',@oficina)
	select @html = REPLACE(@html,'@ACTUAL@',year(@fechaIni))
	select @html = REPLACE(@html,'@ANTERIOR@',year(@fechaIni)-1)
	
    -->reemplazar @lineas@ con los datos formatados
	select @html = REPLACE(@html,'@LINEAS@',@lineas)

    -->REEMPLAZAR LOS ESTILOS Y FORMATOS
    SELECT @html = REPLACE(@html,'@PARES@',@PARES)
    SELECT @html = REPLACE(@html,'@IMPARES@',@IMPARES)
    SELECT @html = REPLACE(@html,'@TITULOS@',@TITULOS)

	select @resumen=@css + @html
	--print @resumen --@
	select  @resumen as retorno
	

