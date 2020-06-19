/* Sequences */
DROP SEQUENCE id_persona_seq;
DROP SEQUENCE id_pais_seq;
DROP SEQUENCE id_estado_seq;
DROP SEQUENCE id_ciudad_seq;
DROP SEQUENCE id_urbanizacion_seq;
DROP SEQUENCE id_calle_seq;
DROP SEQUENCE id_infectado_seq;

/* Tables */
DROP TABLE infectados_covid;
DROP TABLE calles;
DROP TABLE urbanizaciones;
DROP TABLE ciudades;
DROP TABLE estados;
DROP TABLE paises;
DROP TABLE personas;

/* Types */
DROP TYPE persona;
DROP TYPE covid_data;
DROP TYPE historia;
