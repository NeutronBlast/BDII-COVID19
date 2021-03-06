--2 Formas de ver el ususari oactual
SELECT USER FROM DUAL;
show user;

--IMPORTANTE ASEGURAR QUE TIENEN TODOS LOS PERMISOS EJECUTEN ESTO CON EL USUSARIO SYS

GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE TRIGGER,
CREATE PROCEDURE, EXECUTE ANY PROCEDURE, CREATE USER, CREATE ROLE, DROP USER TO usuario_que_creo_las_tablas;

--Ejecutar desde aqui-------------------------------------------------------------------------------------
ALTER SESSION SET "_ORACLE_SCRIPT"=true;

--Roles
--Administrador base de datos-----------------------------------------------------------------------------
CREATE ROLE ADMIN_DB;
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE TRIGGER,
CREATE PROCEDURE, EXECUTE ANY PROCEDURE, CREATE USER, CREATE ROLE, DROP USER TO ADMIN_DB;
GRANT ALL PRIVILEGES TO ADMIN_DB;

--Personal de salud---------------------------------------------------------------------------------------
CREATE ROLE ADMIN_PS;
GRANT CREATE SESSION, CREATE VIEW, CREATE TRIGGER,
CREATE PROCEDURE, EXECUTE ANY PROCEDURE, CREATE USER, DROP USER TO ADMIN_PS;
GRANT ALL ON patologias TO ADMIN_PS;
GRANT ALL ON sintomas TO ADMIN_PS;
GRANT ALL ON insumos TO ADMIN_PS;
GRANT ALL ON recintos_salud TO ADMIN_PS;
GRANT ALL ON historico_tratamiento TO ADMIN_PS;
GRANT ALL ON H_I TO ADMIN_PS;
GRANT ALL ON P_PAT TO ADMIN_PS;
GRANT ALL ON P_S TO ADMIN_PS;
GRANT ALL ON infectados_covid TO ADMIN_PS;
GRANT SELECT ON paises TO ADMIN_PS;
GRANT SELECT ON estados TO ADMIN_PS;
GRANT SELECT ON ciudades TO ADMIN_PS;
GRANT SELECT ON urbanizaciones TO ADMIN_PS;
GRANT SELECT ON calles TO ADMIN_PS;
GRANT SELECT ON personas TO ADMIN_PS;

CREATE ROLE EMP_PS;
GRANT CREATE SESSION TO EMP_PS;
GRANT SELECT ON patologias TO EMP_PS;
GRANT SELECT ON sintomas TO EMP_PS;
GRANT SELECT ON insumos TO EMP_PS;
GRANT SELECT ON paises TO EMP_PS;
GRANT SELECT ON estados TO EMP_PS;
GRANT SELECT ON ciudades TO EMP_PS;
GRANT SELECT ON urbanizaciones TO EMP_PS;
GRANT SELECT ON calles TO EMP_PS;
GRANT SELECT ON personas TO EMP_PS;
GRANT SELECT ON recintos_salud TO EMP_PS;
GRANT SELECT ON historico_tratamiento TO EMP_PS;
GRANT SELECT ON H_I TO EMP_PS;
GRANT SELECT ON P_PAT TO EMP_PS;
GRANT SELECT ON P_S TO EMP_PS;
GRANT SELECT ON infectados_covid TO EMP_PS;

--Personal gubernamental------------------------------------------------------------------------------
CREATE ROLE ADMIN_PG;
GRANT CREATE SESSION, CREATE VIEW, CREATE TRIGGER,
CREATE PROCEDURE, EXECUTE ANY PROCEDURE, CREATE USER, DROP USER TO ADMIN_PG;
GRANT ALL ON historico_cierre_fronteras TO ADMIN_PG;
GRANT ALL ON modelos TO ADMIN_PG;
GRANT ALL ON historico_modelos TO ADMIN_PG;
GRANT ALL ON historico_ayuda_humanitaria TO ADMIN_PG;
GRANT ALL ON A_I TO ADMIN_PG;
GRANT SELECT ON paises TO ADMIN_PG;
GRANT SELECT ON estados TO ADMIN_PG;
GRANT SELECT ON ciudades TO ADMIN_PG;
GRANT SELECT ON urbanizaciones TO ADMIN_PG;
GRANT SELECT ON calles TO ADMIN_PG;
GRANT SELECT ON personas TO ADMIN_PG;

CREATE ROLE EMP_PG;
GRANT CREATE SESSION TO EMP_PG;
GRANT SELECT ON paises TO EMP_PG;
GRANT SELECT ON estados TO EMP_PG;
GRANT SELECT ON ciudades TO EMP_PG;
GRANT SELECT ON urbanizaciones TO EMP_PG;
GRANT SELECT ON calles TO EMP_PG;
GRANT SELECT ON personas TO EMP_PG;
GRANT SELECT ON historico_cierre_fronteras TO EMP_PG;
GRANT SELECT ON modelos TO EMP_PG;
GRANT SELECT ON historico_modelos TO EMP_PG;
GRANT SELECT ON historico_ayuda_humanitaria TO EMP_PG;
GRANT SELECT ON A_I TO EMP_PG;

--Proveedor de internet---------------------------------------------------------------------------------------
CREATE ROLE ADMIN_PI;
GRANT CREATE SESSION, CREATE VIEW, CREATE TRIGGER,
CREATE PROCEDURE, EXECUTE ANY PROCEDURE, CREATE USER, DROP USER TO ADMIN_PI;
GRANT ALL ON proveedores TO ADMIN_PI;
GRANT ALL ON E_P TO ADMIN_PI;
GRANT ALL ON P_PROV TO ADMIN_PI;
GRANT SELECT ON paises TO ADMIN_PI;
GRANT SELECT ON estados TO ADMIN_PI;
GRANT SELECT ON ciudades TO ADMIN_PI;
GRANT SELECT ON urbanizaciones TO ADMIN_PI;
GRANT SELECT ON calles TO ADMIN_PI;
GRANT SELECT ON personas TO ADMIN_PI;

CREATE ROLE EMP_PI;
GRANT CREATE SESSION TO EMP_PI;
GRANT SELECT ON proveedores TO EMP_PI;
GRANT SELECT ON paises TO EMP_PI;
GRANT SELECT ON estados TO EMP_PI;
GRANT SELECT ON ciudades TO EMP_PI;
GRANT SELECT ON urbanizaciones TO EMP_PI;
GRANT SELECT ON calles TO EMP_PI;
GRANT SELECT ON personas TO EMP_PI;
GRANT SELECT ON E_P TO EMP_PI;
GRANT SELECT ON P_PROV TO EMP_PI;

--Personal aerolínea-----------------------------------------------------------------------------------
CREATE ROLE ADMIN_PA;
GRANT CREATE SESSION, CREATE VIEW, CREATE TRIGGER,
CREATE PROCEDURE, EXECUTE ANY PROCEDURE, CREATE USER, DROP USER TO ADMIN_PA;
GRANT ALL ON aerolineas TO ADMIN_PA;
GRANT ALL ON historico_viajes TO ADMIN_PA;
GRANT ALL ON C_HV TO ADMIN_PA;
GRANT ALL ON P_HV TO ADMIN_PA;
GRANT SELECT ON paises TO ADMIN_PA;
GRANT SELECT ON estados TO ADMIN_PA;
GRANT SELECT ON ciudades TO ADMIN_PA;
GRANT SELECT ON urbanizaciones TO ADMIN_PA;
GRANT SELECT ON calles TO ADMIN_PA;
GRANT SELECT ON personas TO ADMIN_PA;

CREATE ROLE EMP_PA;
GRANT CREATE SESSION TO EMP_PA;
GRANT SELECT ON aerolineas TO EMP_PA;
GRANT SELECT ON paises TO EMP_PA;
GRANT SELECT ON estados TO EMP_PA;
GRANT SELECT ON ciudades TO EMP_PA;
GRANT SELECT ON urbanizaciones TO EMP_PA;
GRANT SELECT ON calles TO EMP_PA;
GRANT SELECT ON personas TO EMP_PA;
GRANT SELECT ON historico_viajes TO EMP_PA;
GRANT SELECT ON C_HV TO EMP_PA;
GRANT SELECT ON P_HV TO EMP_PA;

--Users
CREATE USER usuario01 IDENTIFIED BY usuario01
    quota unlimited on USERS;
CREATE USER usuario02 IDENTIFIED BY usuario02
    quota unlimited on USERS;
CREATE USER usuario03 IDENTIFIED BY usuario03;
CREATE USER usuario04 IDENTIFIED BY usuario04;
CREATE USER usuario05 IDENTIFIED BY usuario05
    quota unlimited on USERS;
CREATE USER usuario06 IDENTIFIED BY usuario06;
CREATE USER usuario07 IDENTIFIED BY usuario07;
CREATE USER usuario08 IDENTIFIED BY usuario08
    quota unlimited on USERS;
CREATE USER usuario09 IDENTIFIED BY usuario09;
CREATE USER usuario10 IDENTIFIED BY usuario10;
CREATE USER usuario11 IDENTIFIED BY usuario11
    quota unlimited on USERS;
CREATE USER usuario12 IDENTIFIED BY usuario12;
CREATE USER usuario13 IDENTIFIED BY usuario13;

--Asignar roles---------------------------------------------------------------------------------------------
GRANT ADMIN_DB TO usuario01;
GRANT ADMIN_PS TO usuario02;
GRANT EMP_PS TO usuario03,usuario04;
GRANT ADMIN_PG TO usuario05;
GRANT EMP_PG TO usuario06,usuario07;
GRANT ADMIN_PI TO usuario08;
GRANT EMP_PI TO usuario09,usuario10;
GRANT ADMIN_PA TO usuario11;
GRANT EMP_PA TO usuario12,usuario13;




----------------DROP ROLES AND USERS----------------DROP ROLES AND USERS----------------DROP ROLES AND USERS----------------DROP ROLES AND USERS----------------
DROP USER usuario01;
DROP USER usuario02;
DROP USER usuario03;
DROP USER usuario04;
DROP USER usuario05;
DROP USER usuario06;
DROP USER usuario07;
DROP USER usuario08;
DROP USER usuario09;
DROP USER usuario10;
DROP USER usuario11;
DROP USER usuario12;
DROP USER usuario13;
DROP ROLE ADMIN_DB;
DROP ROLE ADMIN_PS;
DROP ROLE EMP_PS;
DROP ROLE ADMIN_PG;
DROP ROLE EMP_PG;
DROP ROLE ADMIN_PI;
DROP ROLE EMP_PI;
DROP ROLE ADMIN_PA;
DROP ROLE EMP_PA;