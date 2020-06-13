
/* TDA'S */
CREATE OR REPLACE TYPE covid_data AS OBJECT (
    STATIC FUNCTION numero_infectados (id_pais NUMBER) RETURN NUMBER,
    STATIC FUNCTION numero_fallecidos (id_pais NUMBER) RETURN NUMBER,
    STATIC FUNCTION numero_recuperados (id_pais NUMBER) RETURN NUMBER,
    STATIC FUNCTION porcentaje_infectados (pob NUMBER, infec NUMBER) RETURN NUMBER,
    STATIC FUNCTION porcentaje_fallecidos (pob NUMBER, infec NUMBER, fall NUMBER) RETURN NUMBER,
    STATIC FUNCTION porcentaje_recuperados (pob NUMBER, infec NUMBER, recup NUMBER) RETURN NUMBER
);

CREATE OR REPLACE TYPE persona AS OBJECT (
    img     BLOB,
    nom1    VARCHAR(15) NOT NULL,
    nom2    VARCHAR(15),
    ape1    VARCHAR(15) NOT NULL,
    ape2    VARCHAR(15) NOT NULL,
    fec_nac DATE NOT NULL,
    fec_mue DATE,
    genero  VARCHAR(2) NOT NULL,
    STATIC FUNCTION edad (fec_nac DATE) RETURN NUMBER,
    STATIC FUNCTION size_of_img (img BLOB) RETURN NUMBER
);

CREATE OR REPLACE TYPE historia AS OBJECT (
    fec_i DATE NOT NULL,
    fec_f DATE,
    STATIC FUNCTION comprobar_fechas (fec_i DATE, fec_f DATE) RETURN NUMBER
);

/*  Create Table */
CREATE TABLE patologias (
    id       NUMBER PRIMARY KEY,
    nom      VARCHAR(20) NOT NULL
);

CREATE TABLE sintomas (
    id       NUMBER PRIMARY KEY,
    nom      VARCHAR(20) NOT NULL
);

CREATE TABLE proveedores (
    id      NUMBER PRIMARY KEY,
    nom     VARCHAR(20) NOT NULL,
    img     BLOB
);

CREATE TABLE aerolineas (
    id      NUMBER PRIMARY KEY,
    nom     VARCHAR(20) NOT NULL,
    img     BLOB
);

CREATE TABLE modelos (
    id      NUMBER PRIMARY KEY,
    nom     VARCHAR(20) NOT NULL,
    tipo    VARCHAR(20) NOT NULL
);

CREATE TABLE insumos (
    id       NUMBER PRIMARY KEY,
    nom      VARCHAR(20) NOT NULL
);

CREATE TABLE paises (
    id       NUMBER PRIMARY KEY,
    nom      VARCHAR(20) NOT NULL
);

CREATE TABLE estados (
    id        NUMBER PRIMARY KEY,
    nom       VARCHAR(20) NOT NULL,
    id_pais   NUMBER NOT NULL
);

CREATE TABLE ciudades (
    id          NUMBER PRIMARY KEY,
    nom         VARCHAR(20) NOT NULL,
    id_estado   NUMBER NOT NULL
);

CREATE TABLE urbanizaciones (
    id          NUMBER PRIMARY KEY,
    nom         VARCHAR(20) NOT NULL,
    id_ciudad   NUMBER NOT NULL
);

CREATE TABLE calles (
    id      NUMBER PRIMARY KEY,
    nom     VARCHAR(20) NOT NULL,
    id_urb  NUMBER NOT NULL
);

CREATE TABLE personas(
    id  PRIMARY KEY,
    pers persona
);

CREATE TABLE recinto_salud(
    id NUMBER PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    n_camas NUMBER NOTNULL,
    data covid_data,
    id_calle NUMBER NOT NULL,
);

CREATE TABLE historico_cierre_fronteras(
    hist historia,
    id_pais NUMBER NOT NULL
);

CREATE TABLE historico_modelos(
    hist historia,
    id_estado NUMBER NOT NULL,
    id_modelo NUMBER NOT NULL
);

CREATE TABLE historico_ayuda_humanitaria(
    hist historia,
    dinero NUMBER,
    id_pais1 NUMBER NOT NULL,
    id_pais2 NUMBER NOT NULL
);

CREATE TABLE historico_viajes(
    hist historia,
    n_vuelo NUMBER NOT NULL, /*  <-- creo que esto deberia se primary key*/
    id_aero NUMBER NOT NULL,
    id_pais1 NUMBER NOT NULL,
    id_pais2 NUMBER NOT NULL
);

CREATE TABLE historico_tratamiento(
    hist historia,
    id_persona NUMBER NOT NULL,
    id_rec_salud NUMBER NOT NULL,
    PRIMARY KEY (id_persona,id_rec_salud)
);

CREATE TABLE A_I(
    cant NUMBER NOT NULL,
    id_insumo NUMBER NOT NULL,
    /* como que falta una fecha aqui */
    id_pais1 NUMBER NOT NULL,
    id_pais2 NUMBER NOT NULL,
    PRIMARY KEY (id_pais1,id_pais2/*, fecha*/ )
);

CREATE TABLE H_I (
    cant NUMBER NOT NULL,
    id_insumo NUMBER NOT NULL,
    id_rec_salud NUMBER NOT NULL,
    PRIMARY KEY (id_insumo,id_rec_salud)
);

CREATE TABLE E_P (
    id_estado NUMBER NOT NULL,
    id_proveedor NUMBER NOT NULL,
    PRIMARY KEY (id_estado,id_proveedor)
);

CREATE TABLE C_HV (
    id_ciudad NUMBER NOT NULL,
    id_aero NUMBER NOT NULL,
    id_pais1 NUMBER NOT NULL,
    id_pais2 NUMBER NOT NULL,
    PRIMARY KEY (id_ciudad,id_aero,id_pais1,id_pais2)
);

CREATE TABLE P_HV (
    id_persona NUMBER NOT NULL,
    id_aero NUMBER NOT NULL,
    id_pais1 NUMBER NOT NULL,
    id_pais2 NUMBER NOT NULL,
    PRIMARY KEY (id_persona,id_aero,id_pais1,id_pais2)
);

CREATE TABLE P_Pat (
    id_persona NUMBER NOT NULL,
    id_patologia NUMBER NOT NULL,
    PRIMARY KEY (id_persona,id_patologia)
);

CREATE TABLE P_S (
    id_persona NUMBER NOT NULL,
    id_sintoma NUMBER NOT NULL,
    PRIMARY KEY (id_persona,id_sintoma)
);

CREATE TABLE P_Prov (
    id_persona NUMBER NOT NULL,
    id_proveedor NUMBER NOT NULL,
    v_sub NUMBER NOT NULL,
    v_des NUMBER NOT NULL,
    h_dia_inter NUMBER NOT NULL,
    PRIMARY KEY (id_persona,id_proveedor)
);

CREATE TABLE infectados_covi19 (
    id NUMBER NOT NULL,
    id_persona NUMBER NOT NULL,
    fec_i DATE NOT NULL,
    fec_f DATE,
    estado VARCHAR(2),
    id_estado NUMBER,
    id_rec_salud NUMBER,
    PRIMARY KEY (id,id_persona)
);

/* Sequences */
CREATE SEQUENCE patologias_seq;
CREATE SEQUENCE sintomas_seq;
CREATE SEQUENCE proveedores_seq;
CREATE SEQUENCE aerolineas_seq;
CREATE SEQUENCE modelos_seq;
CREATE SEQUENCE insumos_seq;
CREATE SEQUENCE paises_seq;
CREATE SEQUENCE estados_seq;
CREATE SEQUENCE ciudades_seq;
CREATE SEQUENCE urbanizaciones_seq;
CREATE SEQUENCE calles_seq;
CREATE SEQUENCE persona_seq;

/* Constaint foreing keys */
ALTER TABLE estados ADD CONSTRAINT estado_pais_fk FOREIGN KEY (id_pais) REFERENCES paises(id);
ALTER TABLE ciudades ADD CONSTRAINT ciudad_estado_fk FOREIGN KEY (id_estado) REFERENCES estados(id);
ALTER TABLE urbanizaciones ADD CONSTRAINT urbanizacion_ciudad_fk FOREIGN KEY (id_ciudad) REFERENCES ciudades(id);
ALTER TABLE calles ADD CONSTRAINT calles_urbanizacion_fk FOREIGN KEY (id_urb) REFERENCES urbanizaciones(id);
ALTER TABLE historico_cierre_fronteras ADD CONSTRAINT hist_cierre_pais_fk FOREIGN KEY (id_pais) REFERENCES paises(id);
ALTER TABLE historico_modelos ADD CONSTRAINT hist_mod_estado_fk FOREIGN KEY (id_estado) REFERENCES estados(id);
ALTER TABLE historico_modelos ADD CONSTRAINT hist_mod_mod_fk FOREIGN KEY (id_modelo) REFERENCES modelos(id);
ALTER TABLE historico_ayuda_humanitaria ADD CONSTRAINT hist_ayu_pais1_fk FOREIGN KEY (id_pais1) REFERENCES paises(id);
ALTER TABLE historico_ayuda_humanitaria ADD CONSTRAINT hist_ayu_pais2_fk FOREIGN KEY (id_pais2) REFERENCES paises(id);
ALTER TABLE historico_viajes ADD CONSTRAINT hist_via_aero_fk FOREIGN KEY (id_aero) REFERENCES aerolineas(id);
ALTER TABLE historico_viajes ADD CONSTRAINT hist_via_pasi1_fk FOREIGN KEY (id_pais1) REFERENCES paises(id);
ALTER TABLE historico_viajes ADD CONSTRAINT hist_via_pais2_fk FOREIGN KEY (id_pais2) REFERENCES paises(id);
ALTER TABLE recinto_salud ADD CONSTRAINT reci_sal_calle_fk FOREIGN KEY (id_calle) REFERENCES calles(id);
ALTER TABLE historico_tratamiento ADD CONSTRAINT hist_trat_pers_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE historico_tratamiento ADD CONSTRAINT hist_trat_rec_salud_fk FOREIGN KEY (id_rec_salud) REFERENCES recinto_salud(id);
ALTER TABLE A_I ADD CONSTRAINT ai_insumo_fk FOREIGN KEY (id_insumo) REFERENCES insumos(id);
ALTER TABLE A_I ADD CONSTRAINT ai_pais1_fk FOREIGN KEY (id_pais1) REFERENCES paises(id);
ALTER TABLE A_I ADD CONSTRAINT ai_pais2_fk FOREIGN KEY (id_pais2) REFERENCES paises(id);
/* ALTER TABLE A_I ADD CONSTRAINT ai_fecha_fk FOREIGN KEY (id_fecha) REFERENCES ????(fec_i);*/
ALTER TABLE H_I ADD CONSTRAINT hi_insumo_fk FOREIGN KEY (id_insumo) REFERENCES insumos(id);
ALTER TABLE H_I ADD CONSTRAINT hi_rec_salud_fk FOREIGN KEY (id_rec_salud) REFERENCES recinto_salud(id);
ALTER TABLE E_P ADD CONSTRAINT ep_estado_fk FOREIGN KEY (id_estado) REFERENCES estados(id);
ALTER TABLE E_P ADD CONSTRAINT ep_prov_fk FOREIGN KEY (id_proveedor) REFERENCES proveedores(id);
ALTER TABLE C_HV ADD CONSTRAINT chv_ciudad_fk FOREIGN KEY (id_ciudad) REFERENCES ciudades(id);
ALTER TABLE C_HV ADD CONSTRAINT chv_aero_fk FOREIGN KEY (id_aero) REFERENCES aerolineas(id);
ALTER TABLE C_HV ADD CONSTRAINT chv_pais1_fk FOREIGN KEY (id_pais1) REFERENCES paises(id);
ALTER TABLE C_HV ADD CONSTRAINT chv_pais2_fk FOREIGN KEY (id_pais2) REFERENCES paises(id);
ALTER TABLE P_HV ADD CONSTRAINT phv_persona_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE P_HV ADD CONSTRAINT phv_aero_fk FOREIGN KEY (id_aero) REFERENCES aerolineas(id);
ALTER TABLE P_HV ADD CONSTRAINT phv_pais1_fk FOREIGN KEY (id_pais1) REFERENCES paises(id);
ALTER TABLE P_HV ADD CONSTRAINT phv_pais2_fk FOREIGN KEY (id_pais2) REFERENCES paises(id);
ALTER TABLE P_Pat ADD CONSTRAINT ppat_persona_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE P_Pat ADD CONSTRAINT ppat_patologia_fk FOREIGN KEY (id_patologia) REFERENCES patologias(id);
ALTER TABLE P_S ADD CONSTRAINT ps_persona_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE P_S ADD CONSTRAINT ps_sintoma_fk FOREIGN KEY (id_sintoma) REFERENCES sintomas(id);
ALTER TABLE P_Prov ADD CONSTRAINT pprov_persona_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE P_Prov ADD CONSTRAINT pprov_prov_fk FOREIGN KEY (id_proveedor REFERENCES proveedores(id);
ALTER TABLE infectados_covi19 ADD CONSTRAINT inf_persona_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE infectados_covi19 ADD CONSTRAINT inf_estado_fk FOREIGN KEY (id_estado) REFERENCES estados(id);
ALTER TABLE infectados_covi19 ADD CONSTRAINT inf_rec_salud_fk FOREIGN KEY (id_rec_salud) REFERENCES recinto_salud(id);
