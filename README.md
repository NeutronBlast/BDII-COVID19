# BDII-COVID19
 Proyecto de Base de Datos II que consiste en un sistema de reportería de infectados con COVID-19

# Imagenes
 Para que las imágenes funcionen se requiere que se arrastren los archivos de la carpeta `img_proyecto` al directorio raiz `C://`

 Además, se deben tener todos los privilegios desde la conexión que se haga, para ello, desde la conexión a SYS se debe ejecutar el siguiente comando

 `GRANT ALL PRIVILEGES TO FrankHesse;`

# Orden de ejecucion de los scripts
1. **TDA:** Tipos de dato abstractos junto a bodies que no dependen de la creación de alguna tabla
2. **Create Tables:** Tablas con constraints
3. **Inserts:** 16 o más inserts por tabla
4. **TDA Bodies:** Bodies dependientes de tablas creadas
5. **Simulation:** Todos los scripts de la simulación (el orden de compilación no importa)
11. **report_queries/Auxiliars:** Funciones soporte para ciertos reportes
12. **report_queries/Reports**

# Abrir reportes en Jasper
1. Abrir JasperSoft Studio
2. Abrir cualquier archivo `.jrxml` ubicado en la carpeta `reports_jasper`
3. Se presiona el boton para el Dataset y se le da a `Read Fields`
4. Si se cambian los parametros que devuelven imagen por `BLOB` hay que ponerlos otra vez como `java.awt.Image` y darle OK, no hace falta darle a read fields nuevamente
5. Cliquea en Preview para el reporte y coloca los parametros que se pidan

# Parametros recomendados para reportes
+ Personas Infectadas
  1. Pais = 6, Estado = 12, Edad = 21, Patologia = NO
  2. Pais = 6, Estado = 12, Edad = 21, Patologia = SI
  3. Pais = 1, Estado = 1, Edad = 26, Patologia = NO
  4. Pais = 1, Estado = 1, Edad = 26, Patologia = SI
+ Personas con sintomas
  1. Pais = 6, Estado = 12, Edad = 21
  2. Pais = 1, Estado = 1, Edad = 26
+ Viajes
  1. Fecha de Inicio = 01 de Enero de 2020, Fecha Fin = 01 de Junio de 2020
  2. Fecha Inicio = 19 de Junio de 2020, Fecha Fin = 19 de Septiembre de 2020
+ Reporte por paises
  1. Pais = 6, Estado = 12
  2. Pais = 1, Estado = 1
+ Reporte por modelos
  1. Pais = 6
  2. Pais = 1
+ Grafica
  1. Pais = 0, Fecha de Inicio = 30 de Mayo de 2020, Fecha de Fin = 15 de Julio de 2020
  2. Pais = 1, Fecha de Inicio = 01 de Enero de 2020, Fecha de Fin = 31 de Diciembre de 2020