# ResumenEjecutivo
https://github.com/paulmoyasx/ResumenEjecutivo
Plan de solución:
    0) para probar se puede utilizar el script spResumenEjecutivoDUMY.sql

    1) Construir las consultas sql que retnornan los valores para la columna "Actual"
    estas mismas consultas pueden retornar los valores de la columna "Anterior" ajustando las fechas
        * fnResumenVentas.sql
        * fnResumenCobranza.sql
        * fnResumenCuentasPorCobrar.sql
        (estas consultas debem retornar apenas un valor)

    2) Montar una tabla con los valores retornados por las consultas
        * spResumenEjecutivo (este procedure llamas a las funciones fn)
        #necesita una funcion para retornar el nombre del mes en español fnNombreMes ó DATENAME(MONTH, GETDATE())

    3) Generar el HTML con el mensaje y resumen formatado (ver ResumenEjecutivo.html)
        * spResumenEjecutivoHTML (llama al spResumenEjecutivo )

    4) Enviar Email(s) (analizar sin ejecutar dbMailConfig.sql)
        #Si se tiene la opcion de utilizar el DBMail y podria crear job(s) para automatizar
        #Otra alternativa podria ser crear un programa para consultar los datos y enviar Email(s)
        posiblemente el programa podria ser creado en c#, VBS, JavaSCript, pyhton algun otro de facil dominio y acesso

        * spResumenEjecutivoEMAIL (llama al spResumenEjecutivoHTML )

    
    Ejemplos de las llamadas a los procedures:
    
        exec spResumenEjecutivo 'CLCH','2019/01/01' ,'2019/01/31'            

        exec spResumenEjecutivoHTML 'CLCH','2019/01/01' ,'2019/01/31'            
        
        exec spResumenEjecutivoEmail 'CLCH','2019/01/01' ,'2019/01/31',''

Antes de iniciar responder estas preguntas:
    Es posible crear objetos nuevos en la base de datos destino? (procedures y funciones)
    Caso no, podria ser creada una nueva base de datos para las customizaciones?
        
    Es viable utilizar el DBMail de SQL Server ?
    Caso no, Se tiene acesso a algun lenguaje de programacion?

    #el procedure tambien puede ser consultado por tablas dinamicas de excel (ver ResumenEjecutivo.xlsx ó ResumenExcel.png)



