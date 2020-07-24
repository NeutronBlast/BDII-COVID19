/* Directorios */
DROP DIRECTORY DIR_AIRLINES;
DROP DIRECTORY DIR_BANDERAS;
DROP DIRECTORY DIR_PEOPLE;
DROP DIRECTORY DIR_PROV;

/* Aux Functions */
DROP FUNCTION POBLACION_PAIS;
DROP FUNCTION VISITAS;
DROP FUNCTION concat_patologia;
DROP FUNCTION concat_sintoma;
DROP FUNCTION concat_fec_sintoma;
DROP FUNCTION tratado_si_no;

DROP FUNCTION CONCAT_INSUMO;

/* Procedures */
DROP PROCEDURE CADENA_INFECCION;
DROP PROCEDURE DESTINO;
DROP PROCEDURE VUELOS;
DROP PROCEDURE CONTROL_FRONTERAS;
DROP PROCEDURE HOSPITALES;
DROP PROCEDURE AYUDA_HUMANITARIA;
DROP PROCEDURE INTERNET;
DROP PROCEDURE REPORTE_1;
DROP PROCEDURE REPORTE_2;
DROP PROCEDURE REPORTE_3;
DROP PROCEDURE REPORTE_4;
DROP PROCEDURE REPORTE_5;
DROP PROCEDURE REPORTE_6;
DROP PROCEDURE REPORTE_7;
DROP PROCEDURE REPORTE_8;
DROP PROCEDURE REPORTE_9;
DROP PROCEDURE REPORTE_10;

/* Sequences */
DROP SEQUENCE id_patologia_seq;
DROP SEQUENCE id_sintoma_seq;
DROP SEQUENCE id_proveedor_seq;
DROP SEQUENCE id_aerolinea_seq;
DROP SEQUENCE id_insumo_seq;
DROP SEQUENCE id_pais_seq;
DROP SEQUENCE id_estado_seq;
DROP SEQUENCE id_ciudad_seq;
DROP SEQUENCE id_urbanizacion_seq;
DROP SEQUENCE id_calle_seq;
DROP SEQUENCE id_persona_seq;
DROP SEQUENCE id_recinto_salud_seq;
DROP SEQUENCE id_hist_cierre_seq;
DROP SEQUENCE id_hist_modelo_seq;
DROP SEQUENCE id_hist_viajes_seq;
DROP SEQUENCE id_hist_tratamiento_seq;
DROP SEQUENCE id_infectado_seq;
DROP SEQUENCE id_hist_ayuda_seq;
DROP SEQUENCE id_p_prov_seq;


/* Tables */
DROP TABLE patologias CASCADE CONSTRAINTS;
DROP TABLE sintomas CASCADE CONSTRAINTS;
DROP TABLE proveedores CASCADE CONSTRAINTS;
DROP TABLE aerolineas CASCADE CONSTRAINTS;
DROP TABLE insumos CASCADE CONSTRAINTS;
DROP TABLE paises CASCADE CONSTRAINTS;
DROP TABLE estados CASCADE CONSTRAINTS;
DROP TABLE ciudades CASCADE CONSTRAINTS;
DROP TABLE urbanizaciones CASCADE CONSTRAINTS;
DROP TABLE calles CASCADE CONSTRAINTS;
DROP TABLE personas CASCADE CONSTRAINTS;
DROP TABLE recintos_salud CASCADE CONSTRAINTS;
DROP TABLE historico_cierre_fronteras CASCADE CONSTRAINTS;
DROP TABLE modelos CASCADE CONSTRAINTS;
DROP TABLE historico_modelos CASCADE CONSTRAINTS;
DROP TABLE historico_ayuda_humanitaria CASCADE CONSTRAINTS;
DROP TABLE historico_viajes CASCADE CONSTRAINTS;
DROP TABLE historico_tratamiento CASCADE CONSTRAINTS;
DROP TABLE A_I CASCADE CONSTRAINTS;
DROP TABLE H_I CASCADE CONSTRAINTS;
DROP TABLE E_P CASCADE CONSTRAINTS;
DROP TABLE C_HV CASCADE CONSTRAINTS;
DROP TABLE P_HV CASCADE CONSTRAINTS;
DROP TABLE P_PAT CASCADE CONSTRAINTS;
DROP TABLE P_S CASCADE CONSTRAINTS;
DROP TABLE P_PROV CASCADE CONSTRAINTS;  
DROP TABLE infectados_covid CASCADE CONSTRAINTS;

/* Types */
DROP TYPE persona FORCE;
DROP TYPE covid_data FORCE;
DROP TYPE historia FORCE;
