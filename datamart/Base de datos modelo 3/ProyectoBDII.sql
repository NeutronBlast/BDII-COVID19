/* creates */

CREATE OR REPLACE TYPE Direccion AS OBJECT(
detalle_direccion varchar(30),
STATIC FUNCTION generar_direccion(auxEstado number, direccion varchar) RETURN varchar
);
/
CREATE OR REPLACE TYPE Fechas_inicio_fin AS OBJECT(
fecha_inicio date,
fecha_fin date,
STATIC FUNCTION validar_fechas (fecha_inicio date, fecha_fin date) RETURN date
);
/

CREATE OR REPLACE TYPE Cantidad AS OBJECT(
cantidad number,
STATIC FUNCTION validar_cantidad (cantidad number) RETURN number
);

/
CREATE TABLE Lugar(
  id number primary key,
  tipo varchar(15),
  nombre_lugar varchar(30),
  poblacion number,    
  fk_lugar number,                                                   
  bandera blob,                                       
  CONSTRAINT Fk_Lugar_lugar FOREIGN KEY(fk_lugar) references Lugar(id) 
);

CREATE TABLE Aerolinea (
  id number primary key,
  nombre_aerolinea varchar(30),
  logo blob                        
);

CREATE TABLE Vuelo(
  numero_vuelo number primary key,
  fechas_inicio_fin Fechas_inicio_fin,               
  fk_lugar_salida number,
  fk_lugar_llegada number,
  fk_aerolinea number,
  CONSTRAINT FK_Vuelo_lugarS FOREIGN KEY(fk_lugar_salida) references Lugar(id),
  CONSTRAINT FK_Vuelo_lugarL FOREIGN KEY(fk_lugar_llegada) references Lugar(id),
  CONSTRAINT FK_Vuelo_aerolinea FOREIGN KEY(fk_aerolinea) references Aerolinea(id)
);

CREATE TABLE Centro_de_Salud (
  id number primary key,
  nombre_clinica varchar(30),
  camas_disponibles number,
  camas_totales number,
  tipo varchar(15),
  fk_lugar number,
  direccion Direccion,
  CONSTRAINT Fk_Centro_lugar FOREIGN KEY(fk_lugar) references Lugar(id)                     
);

CREATE TABLE Persona (
  id number primary key,
  primer_nombre varchar(20),
  segundo_nombre varchar(20),
  primer_apellido varchar(20),
  segundo_apellido varchar(20),
  fecha_de_nacimiento date,
  genero varchar(1),
  tratado number(1),                                               
  foto blob,                                
  direccion Direccion,                              
  fk_lugar number,
  fk_centroS number,
  CONSTRAINT FK_Persona_lugar FOREIGN KEY(fk_lugar) references Lugar(id),
  CONSTRAINT FK_Persona_centroS FOREIGN KEY(fk_centroS) references Centro_de_Salud(id)
);

CREATE TABLE Viaje (
  id number primary key,
  fechas_inicio_fin Fechas_inicio_fin,
  fk_persona number,
  CONSTRAINT FK_Persona_viaje FOREIGN KEY(fk_persona) references Persona(id)          
);

CREATE TABLE Vuelo_y_Viaje (
  id number primary key,
  fk_vuelo number,
  fk_viaje number,
  CONSTRAINT FK_VueloPersona_vuelo FOREIGN KEY(fk_vuelo) references Vuelo(numero_vuelo),
  CONSTRAINT FK_VueloPersona_viaje FOREIGN KEY(fk_viaje) references Viaje(id)
);

CREATE TABLE Ciudad_visitada (
  id number primary key,
  fk_viaje number,
  fk_lugar number,
  CONSTRAINT FK_ciudadvis_viaje FOREIGN KEY(fk_viaje) references Viaje(id),
  CONSTRAINT FK_ciudadvis_lugar FOREIGN KEY(fk_lugar) references Lugar(id)
);

CREATE TABLE Proveedor_Internet (
  id number primary key,
  nombre_proveedor varchar(30),
  velocidad_subida_ofrecida number,
  velocidad_bajada_ofrecida number,
  logo blob
);

CREATE TABLE Modelo (
  id number primary key,
  nombre_modelo varchar(30),
  descripcion varchar(40)
);

CREATE TABLE Ayuda_humanitaria (
  id number primary key,
  cantidad_dinero Cantidad,                   
  fechas_inicio_fin Fechas_inicio_fin,                            
  fk_salida number,
  fk_llegada number, 
  CONSTRAINT FK_Ayuda_salida FOREIGN KEY(fk_salida) references Lugar(id),
  CONSTRAINT FK_Ayuda_llegada FOREIGN KEY(fk_llegada) references Lugar(id)
);

CREATE TABLE Sintoma (
  id number primary key,
  nombre_sintoma varchar(30)
);

CREATE TABLE Patologia (
  id number primary key,
  nombre_patologia varchar(20)
);

CREATE TABLE Insumo (
  id number primary key,
  nombre_insumo varchar(20)
);

CREATE TABLE Estado_salud (
  clave number primary key,
  nombre_estado varchar(20)
);

CREATE TABLE Persona_y_Patologia (
  id number primary key,
  fk_persona number,
  fk_patologia number,
  CONSTRAINT FK_PersonaPatologia_pesona FOREIGN KEY(fk_persona) references Persona(id),
  CONSTRAINT FK_PersonaPatologia_patologia FOREIGN KEY(fk_patologia) references Patologia(id)
);

CREATE TABLE Lugar_y_modelo (
  id number primary key,
  fechas_inicio_fin Fechas_inicio_fin,          
  fk_lugar number,
  fk_modelo number,
  CONSTRAINT FK_LugarModelo_lugar FOREIGN KEY(fk_lugar) references Lugar(id),
  CONSTRAINT FK_LugarModel_modelo FOREIGN KEY(fk_modelo) references Modelo(id)
);

CREATE TABLE Cierre_fronteras (
  id number primary key,
  fechas_inicio_fin Fechas_inicio_fin,         
  fk_lugarModelo number,
  CONSTRAINT FK_CierreF_lugarModelo FOREIGN KEY(fk_lugarModelo) references Lugar_y_modelo(id)
);

CREATE TABLE Persona_y_Sintoma (
  id number primary key,
  fecha_sintoma date,
  fk_persona number,
  fk_sintoma number,
  CONSTRAINT FK_PersonaSintoma_pesona FOREIGN KEY(fk_persona) references Persona(id),
  CONSTRAINT FK_PersonaSintoma_sintoma FOREIGN KEY(fk_sintoma) references Sintoma(id)
);

CREATE TABLE Ayuda_humanitaria_y_Insumo (
  id number primary key,
  cantidad_insumo Cantidad,                
  fk_ayuda number,
  fk_insumo number,
  CONSTRAINT FK_AyudaInsumo_ayuda FOREIGN KEY(fk_ayuda) references Ayuda_humanitaria(id),
  CONSTRAINT FK_AyudaInsumo_insumo FOREIGN KEY(fk_insumo) references Insumo(id)
);

CREATE TABLE Centro_de_Salud_y_Insumo (
  id number primary key,
  cantidad_insumo Cantidad,                  
  fk_centrodeSalud number,
  fk_insumo number,
  CONSTRAINT FK_CentroInsumo_centro FOREIGN KEY(fk_centrodeSalud) references Centro_de_Salud(id),
  CONSTRAINT FK_CentroInsumoo_insumo FOREIGN KEY(fk_insumo) references Insumo(id)
);

CREATE TABLE Proveedor_Internet_y_Lugar (
  id number primary key,
  fk_internet number,
  fk_lugar number,
  CONSTRAINT FK_InternetLugar_internet FOREIGN KEY(fk_internet) references Proveedor_Internet(id),
  CONSTRAINT FK_InternetLugar_lugar FOREIGN KEY(fk_lugar) references Lugar(id)
);

CREATE TABLE Historico_internet (
  id number primary key,
  velocidad_prom_subida number,
  velocidad_prom_descarga number,
  horas_interrupcion number,
  fecha date,
  fk_proveedor number,
  CONSTRAINT FK_Historico_proveedor FOREIGN KEY(fk_proveedor) references Proveedor_Internet_y_Lugar(id)
);

CREATE TABLE Persona_y_Estado (
  id number primary key,
  fechas_inicio_fin Fechas_inicio_fin,
  fk_persona number,
  fk_estado number,
  CONSTRAINT FK_PersonaEstado_pesona FOREIGN KEY(fk_persona) references Persona(id),
  CONSTRAINT FK_PersonaEstado_estado FOREIGN KEY(fk_estado) references Estado_salud(clave)
);

/

CREATE SEQUENCE cedulaPersona
START WITH 1
INCREMENT BY 1;

/
CREATE TRIGGER cedulaPersona
BEFORE INSERT ON Persona
FOR EACH ROW
BEGIN
SELECT cedulaPersona.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idLugar
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idLugar
BEFORE INSERT ON Lugar
FOR EACH ROW
BEGIN
SELECT idLugar.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idAerolinea
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idAerolinea
BEFORE INSERT ON Aerolinea
FOR EACH ROW
BEGIN
SELECT idAerolinea.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE numero_vuelo
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER numero_vuelo
BEFORE INSERT ON Vuelo
FOR EACH ROW
BEGIN
SELECT numero_vuelo.NEXTVAL INTO :NEW.numero_vuelo FROM DUAL;
END;
/
CREATE SEQUENCE idcentro_de_salud
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idcentro_de_salud
BEFORE INSERT ON Centro_de_Salud
FOR EACH ROW
BEGIN
SELECT idcentro_de_salud.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idvuelo_y_viaje
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idvuelo_y_viaje
BEFORE INSERT ON Vuelo_y_viaje
FOR EACH ROW
BEGIN
SELECT idvuelo_y_viaje.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idproveedor_internet
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idproveedor_internet
BEFORE INSERT ON Proveedor_Internet
FOR EACH ROW
BEGIN
SELECT idproveedor_internet.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idviaje
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idviaje
BEFORE INSERT ON Viaje
FOR EACH ROW
BEGIN
SELECT idviaje.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idmodelo
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idmodelo
BEFORE INSERT ON Modelo
FOR EACH ROW
BEGIN
SELECT idmodelo.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idayuda_humanitaria
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idayuda_humanitaria
BEFORE INSERT ON Ayuda_humanitaria
FOR EACH ROW
BEGIN
SELECT idayuda_humanitaria.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idsintoma
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idsintoma
BEFORE INSERT ON Sintoma
FOR EACH ROW
BEGIN
SELECT idsintoma.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idpatologia 
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idpatologia
BEFORE INSERT ON Patologia
FOR EACH ROW
BEGIN
SELECT idpatologia.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idinsumo
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idinsumo
BEFORE INSERT ON Insumo
FOR EACH ROW
BEGIN
SELECT idinsumo.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idestado_salud
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idestado_salud
BEFORE INSERT ON Estado_salud
FOR EACH ROW
BEGIN
SELECT idestado_salud.NEXTVAL INTO :NEW.clave FROM DUAL;
END;
/
CREATE SEQUENCE idpersona_y_patologia
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idpersona_y_patologia
BEFORE INSERT ON Persona_y_Patologia
FOR EACH ROW
BEGIN
SELECT idpersona_y_patologia.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idlugar_y_modelo
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idlugar_y_modelo
BEFORE INSERT ON Lugar_y_modelo
FOR EACH ROW
BEGIN
SELECT idlugar_y_modelo.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idcierre_fronteras
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idcierre_fronteras
BEFORE INSERT ON Cierre_fronteras
FOR EACH ROW
BEGIN
SELECT idcierre_fronteras.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idpersona_y_sintoma
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idpersona_y_sintoma
BEFORE INSERT ON Persona_y_Sintoma
FOR EACH ROW
BEGIN
SELECT idpersona_y_sintoma.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idayuda_humanitaria_y_insumo
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idayuda_humanitaria_y_insumo
BEFORE INSERT ON Ayuda_humanitaria_y_Insumo
FOR EACH ROW
BEGIN
SELECT idayuda_humanitaria_y_insumo.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idcentro_de_salud_y_insumo
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idcentro_de_salud_y_insumo
BEFORE INSERT ON Centro_de_Salud_y_Insumo
FOR EACH ROW
BEGIN
SELECT idcentro_de_salud_y_insumo.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idproveedor_internet_y_lugar
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idproveedor_internet_y_lugar
BEFORE INSERT ON Proveedor_Internet_y_Lugar
FOR EACH ROW
BEGIN
SELECT idproveedor_internet_y_lugar.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idhistorico_internet
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idhistorico_internet
BEFORE INSERT ON Historico_internet
FOR EACH ROW
BEGIN
SELECT idhistorico_internet.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idpersona_y_estado
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idpersona_y_estado
BEFORE INSERT ON Persona_y_Estado
FOR EACH ROW
BEGIN
SELECT idpersona_y_estado.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE SEQUENCE idciudad_visitada
START WITH 1
INCREMENT BY 1;
/
CREATE TRIGGER idciudad_visitada
BEFORE INSERT ON Ciudad_visitada
FOR EACH ROW
BEGIN
SELECT idciudad_visitada.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/
CREATE OR REPLACE TYPE BODY Direccion IS
STATIC FUNCTION generar_direccion (auxEstado number, direccion varchar) RETURN varchar
IS
dirFinal varchar(50);
aux varchar(50);
auxPais number;
BEGIN
dirFinal := '';
select fk_lugar into auxPais from lugar where id = auxEstado;
select nombre_lugar into aux from lugar where id = auxPais;
dirFinal := dirFinal + aux + ', ';
select nombre_lugar into aux from lugar where id = auxEstado;
dirFinal := dirFinal + aux + '. ' + direccion;
RETURN dirFinal;
END;
END;
/
CREATE OR REPLACE TYPE BODY Fechas_inicio_fin IS
STATIC FUNCTION validar_fechas (fecha_inicio date, fecha_fin date) RETURN date
IS
BEGIN
IF fecha_fin >= fecha_inicio THEN
RETURN fecha_inicio;
ELSE
RAISE_APPLICATION_ERROR(-20001, 'Error: la fecha de salida no puede ser antes que la de llegada.');
END IF;
END;
END;
/
CREATE OR REPLACE TYPE BODY Cantidad IS
STATIC FUNCTION validar_cantidad (cantidad number) RETURN number
IS
BEGIN
IF cantidad>=0 THEN
RETURN cantidad;
ELSE
RAISE_APPLICATION_ERROR(-20001, 'No se aceptan valores negativos');
END IF;
END;
END;
