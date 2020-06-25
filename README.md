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
5. **Simulation/Infection Chain:** Correspondiente a las infecciones por COVID-19
6. **Simulation/Borders:** Control de fronteras
7. **Simulation/Flights:** Vuelos
8. **Simulation/Hospitals:** Control de insumos
9. **Simulation/Help:** Ayuda humanitaria
10. **Simulation/Internet:** Internet
11. **report_queries/Auxiliars:** Funciones soporte para ciertos reportes
12. **report_queries/Reports**

# Abrir reportes en Jasper
1. Abrir JasperSoft Studio
2. Abrir cualquier archivo `.jrxml` ubicado en la carpeta `reports_jasper`
3. Se presiona el boton para el Dataset y se le da a `Read Fields`
4. Si se cambian los parametros que devuelven imagen por `BLOB` hay que ponerlos otra vez como `java.awt.Image` y darle OK, no hace falta darle a read fields nuevamente
5. Cliquea en Preview para el reporte y coloca los parametros que se pidan

# Parametros recomendados para reportes
1. (WIP)
2. (WIP)
3. (WIP)
4. (WIP)
5. (WIP)
6. (WIP)