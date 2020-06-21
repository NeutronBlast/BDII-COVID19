CREATE TABLE aerolineas (
    id      NUMBER PRIMARY KEY,
    nom     VARCHAR(100) NOT NULL,
    img     BLOB
);

CREATE TABLE paises (
    id       NUMBER PRIMARY KEY,
    nom      VARCHAR(100) NOT NULL,
    bandera BLOB
);

CREATE TABLE estados (
    id        NUMBER PRIMARY KEY,
    nom       VARCHAR(100) NOT NULL,
    id_pais   NUMBER NOT NULL,
    data covid_data
);

CREATE TABLE ciudades (
    id          NUMBER PRIMARY KEY,
    nom         VARCHAR(100) NOT NULL,
    id_estado   NUMBER NOT NULL
);

CREATE TABLE urbanizaciones (
    id          NUMBER PRIMARY KEY,
    nom         VARCHAR(100) NOT NULL,
    id_ciudad   NUMBER NOT NULL
);

CREATE TABLE calles (
    id      NUMBER PRIMARY KEY,
    nom     VARCHAR(20) NOT NULL,
    num     NUMBER NOT NULL,
    id_urb  NUMBER NOT NULL
);

CREATE TABLE personas(
    id NUMBER PRIMARY KEY,
    pers persona,
    id_calle NUMBER NOT NULL
);

CREATE TABLE historico_viajes(
    id NUMBER PRIMARY KEY,
    hist historia,
    n_vuelo NUMBER NOT NULL,
    id_aero NUMBER NOT NULL,
    id_estado_1 NUMBER NOT NULL,
    id_estado_2 NUMBER NOT NULL
);

CREATE TABLE infectados_covid (
    id NUMBER PRIMARY KEY,
    hist historia,
    estado VARCHAR(5) NOT NULL,
    id_persona NUMBER NOT NULL,
    id_hist_trat NUMBER,
    id_estado NUMBER NOT NULL
);

CREATE TABLE sintomas (
    id       NUMBER PRIMARY KEY,
    nom      VARCHAR(50) NOT NULL
);

CREATE TABLE P_HV (
    id_viaje NUMBER NOT NULL,
    id_persona NUMBER NOT NULL,
    PRIMARY KEY (id_viaje, id_persona)
);

CREATE TABLE P_S (
    id_persona NUMBER NOT NULL,
    id_sintoma NUMBER NOT NULL,
    fec_i DATE
);

CREATE TABLE historico_tratamiento(
    id NUMBER PRIMARY KEY,
    hist historia,
    id_persona NUMBER NOT NULL,
    id_rec_salud NUMBER NOT NULL
);

CREATE TABLE historico_cierre_fronteras(
    id NUMBER PRIMARY KEY,
    hist historia,
    id_pais NUMBER NOT NULL
);

CREATE TABLE recintos_salud(
    id NUMBER PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    n_camas NUMBER NOT NULL,
    id_calle NUMBER NOT NULL
);

/* Sequences */
CREATE SEQUENCE id_aerolinea_seq;
CREATE SEQUENCE id_pais_seq;
CREATE SEQUENCE id_estado_seq;
CREATE SEQUENCE id_ciudad_seq;
CREATE SEQUENCE id_urbanizacion_seq;
CREATE SEQUENCE id_calle_seq;
CREATE SEQUENCE id_persona_seq;
CREATE SEQUENCE id_hist_viajes_seq;
CREATE SEQUENCE id_infectado_seq;
CREATE SEQUENCE id_sintoma_seq;
CREATE SEQUENCE id_hist_tratamiento_seq;
CREATE SEQUENCE id_recinto_salud_seq;
CREATE SEQUENCE id_hist_cierre_seq;


