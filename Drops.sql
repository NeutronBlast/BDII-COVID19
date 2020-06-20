/* Procedures */
DROP PROCEDURE CADENA_INFECCION_LM;

/* Sequences */
DROP SEQUENCE id_persona_seq;
DROP SEQUENCE id_pais_seq;
DROP SEQUENCE id_estado_seq;
DROP SEQUENCE id_ciudad_seq;
DROP SEQUENCE id_urbanizacion_seq;
DROP SEQUENCE id_calle_seq;
DROP SEQUENCE id_infectado_seq;
DROP SEQUENCE id_hist_viajes_seq;
DROP SEQUENCE id_aerolinea_seq;


/* Tables */
DROP TABLE historico_viajes;
DROP TABLE P_HV;
DROP TABLE infectados_covid;
DROP TABLE calles;
DROP TABLE urbanizaciones;
DROP TABLE ciudades;
DROP TABLE estados;
DROP TABLE paises;
DROP TABLE personas;
DROP TABLE aerolineas;

/* Types */
DROP TYPE persona FORCE;
DROP TYPE covid_data FORCE;
DROP TYPE historia FORCE;
