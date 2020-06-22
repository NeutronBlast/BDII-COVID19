/*  Create Table */
CREATE TABLE patologias (
    id       NUMBER PRIMARY KEY,
    nom      VARCHAR(50) NOT NULL
);

CREATE TABLE sintomas (
    id       NUMBER PRIMARY KEY,
    nom      VARCHAR(50) NOT NULL
);

CREATE TABLE proveedores (
    id      NUMBER PRIMARY KEY,
    nom     VARCHAR(100) NOT NULL,
    img     BLOB
);

CREATE TABLE aerolineas (
    id      NUMBER PRIMARY KEY,
    nom     VARCHAR(100) NOT NULL,
    img     BLOB
);

CREATE TABLE insumos (
    id       NUMBER PRIMARY KEY,
    nom      VARCHAR(100) NOT NULL
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

CREATE TABLE recintos_salud(
    id NUMBER PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    n_camas NUMBER NOT NULL,
    datos covid_data,
    id_calle NUMBER NOT NULL
);

CREATE TABLE historico_cierre_fronteras(
    id NUMBER PRIMARY KEY,
    hist historia,
    id_pais NUMBER NOT NULL
);

CREATE TABLE modelos (
    id      NUMBER PRIMARY KEY,
    nom     VARCHAR(50) NOT NULL
);

CREATE TABLE historico_modelos(
    id NUMBER PRIMARY KEY, 
    hist historia,
    id_estado NUMBER NOT NULL,
    id_modelo NUMBER NOT NULL
);

CREATE TABLE historico_ayuda_humanitaria(
    id NUMBER PRIMARY KEY,
    hist historia,
    dinero NUMBER,
    id_pais_1 NUMBER NOT NULL,
    id_pais_2 NUMBER NOT NULL
);

CREATE TABLE historico_viajes(
    id NUMBER PRIMARY KEY,
    hist historia,
    n_vuelo NUMBER NOT NULL,
    id_aero NUMBER NOT NULL,
    id_estado_1 NUMBER NOT NULL,
    id_estado_2 NUMBER NOT NULL
);

CREATE TABLE historico_tratamiento(
    id NUMBER PRIMARY KEY,
    hist historia,
    id_persona NUMBER NOT NULL,
    id_rec_salud NUMBER NOT NULL
);

CREATE TABLE A_I(
    cant NUMBER NOT NULL,
    id_insumo NUMBER NOT NULL,
    id_ayuda NUMBER NOT NULL,
    PRIMARY KEY (id_insumo,id_ayuda)
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
    id_viaje NUMBER NOT NULL,
    id_ciudad NUMBER NOT NULL,
    PRIMARY KEY (id_viaje, id_ciudad)
);

CREATE TABLE P_HV (
    id_viaje NUMBER NOT NULL,
    id_persona NUMBER NOT NULL,
    PRIMARY KEY (id_viaje, id_persona)
);

CREATE TABLE P_PAT (
    id_persona NUMBER NOT NULL,
    id_patologia NUMBER NOT NULL,
    PRIMARY KEY (id_persona,id_patologia)
);

CREATE TABLE P_S (
    id_persona NUMBER NOT NULL,
    id_sintoma NUMBER NOT NULL,
    fec_i DATE
);

CREATE TABLE P_PROV (
    id NUMBER PRIMARY KEY,
    id_persona NUMBER NOT NULL,
    id_proveedor NUMBER NOT NULL,
    v_sub NUMBER NOT NULL,
    v_des NUMBER NOT NULL,
    h_int NUMBER NOT NULL,
    hist historia
);

CREATE TABLE infectados_covid (
    id NUMBER PRIMARY KEY,
    hist historia,
    estado VARCHAR(5) NOT NULL,
    id_persona NUMBER NOT NULL,
    id_hist_trat NUMBER,
    id_estado NUMBER NOT NULL
);

/* Sequences */
CREATE SEQUENCE id_patologia_seq;
CREATE SEQUENCE id_sintoma_seq;
CREATE SEQUENCE id_proveedor_seq;
CREATE SEQUENCE id_aerolinea_seq;
CREATE SEQUENCE id_insumo_seq;
CREATE SEQUENCE id_pais_seq;
CREATE SEQUENCE id_estado_seq;
CREATE SEQUENCE id_ciudad_seq;
CREATE SEQUENCE id_urbanizacion_seq;
CREATE SEQUENCE id_calle_seq;
CREATE SEQUENCE id_persona_seq;
CREATE SEQUENCE id_recinto_salud_seq;
CREATE SEQUENCE id_hist_cierre_seq;
CREATE SEQUENCE id_hist_modelo_seq;
CREATE SEQUENCE id_hist_viajes_seq;
CREATE SEQUENCE id_hist_tratamiento_seq;
CREATE SEQUENCE id_infectado_seq;
CREATE SEQUENCE id_hist_ayuda_seq;
CREATE SEQUENCE id_p_prov_seq;

/* Constaint foreing keys */
ALTER TABLE estados ADD CONSTRAINT estado_pais_fk FOREIGN KEY (id_pais) REFERENCES paises(id);
ALTER TABLE ciudades ADD CONSTRAINT ciudad_estado_fk FOREIGN KEY (id_estado) REFERENCES estados(id);
ALTER TABLE urbanizaciones ADD CONSTRAINT urbanizacion_ciudad_fk FOREIGN KEY (id_ciudad) REFERENCES ciudades(id);
ALTER TABLE calles ADD CONSTRAINT calles_urbanizacion_fk FOREIGN KEY (id_urb) REFERENCES urbanizaciones(id);
ALTER TABLE personas ADD CONSTRAINT personas_calles_fk FOREIGN KEY (id_calle) REFERENCES calles(id);
ALTER TABLE historico_cierre_fronteras ADD CONSTRAINT hist_cierre_pais_fk FOREIGN KEY (id_pais) REFERENCES paises(id);
ALTER TABLE historico_modelos ADD CONSTRAINT hist_mod_estado_fk FOREIGN KEY (id_estado) REFERENCES estados(id);
ALTER TABLE historico_modelos ADD CONSTRAINT hist_mod_mod_fk FOREIGN KEY (id_modelo) REFERENCES modelos(id);
ALTER TABLE historico_ayuda_humanitaria ADD CONSTRAINT hist_ayu_pais1_fk FOREIGN KEY (id_pais_1) REFERENCES paises(id);
ALTER TABLE historico_ayuda_humanitaria ADD CONSTRAINT hist_ayu_pais2_fk FOREIGN KEY (id_pais_2) REFERENCES paises(id);
ALTER TABLE historico_viajes ADD CONSTRAINT hist_via_aero_fk FOREIGN KEY (id_aero) REFERENCES aerolineas(id);
ALTER TABLE historico_viajes ADD CONSTRAINT hist_via_pasi1_fk FOREIGN KEY (id_estado_1) REFERENCES estados(id);
ALTER TABLE historico_viajes ADD CONSTRAINT hist_via_pais2_fk FOREIGN KEY (id_estado_2) REFERENCES estados(id);
ALTER TABLE recintos_salud ADD CONSTRAINT reci_sal_calle_fk FOREIGN KEY (id_calle) REFERENCES calles(id);
ALTER TABLE historico_tratamiento ADD CONSTRAINT hist_trat_pers_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE historico_tratamiento ADD CONSTRAINT hist_trat_rec_salud_fk FOREIGN KEY (id_rec_salud) REFERENCES recintos_salud(id);
ALTER TABLE A_I ADD CONSTRAINT ai_insumo_fk FOREIGN KEY (id_insumo) REFERENCES insumos(id);
ALTER TABLE A_I ADD CONSTRAINT ai_ayuda_fk FOREIGN KEY (id_ayuda) REFERENCES historico_ayuda_humanitaria(id);
ALTER TABLE H_I ADD CONSTRAINT hi_insumo_fk FOREIGN KEY (id_insumo) REFERENCES insumos(id);
ALTER TABLE H_I ADD CONSTRAINT hi_rec_salud_fk FOREIGN KEY (id_rec_salud) REFERENCES recintos_salud(id);
ALTER TABLE E_P ADD CONSTRAINT ep_estado_fk FOREIGN KEY (id_estado) REFERENCES estados(id);
ALTER TABLE E_P ADD CONSTRAINT ep_prov_fk FOREIGN KEY (id_proveedor) REFERENCES proveedores(id);
ALTER TABLE C_HV ADD CONSTRAINT c_hv_viaje_fk FOREIGN KEY (id_viaje) REFERENCES historico_viajes(id);
ALTER TABLE C_HV ADD CONSTRAINT c_hv_ciudad_fk FOREIGN KEY (id_ciudad) REFERENCES ciudades(id);
ALTER TABLE P_HV ADD CONSTRAINT p_hv_persona_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE P_HV ADD CONSTRAINT p_hv_viaje_fk FOREIGN KEY (id_viaje) REFERENCES historico_viajes(id);
ALTER TABLE P_PAT ADD CONSTRAINT ppat_persona_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE P_PAT ADD CONSTRAINT ppat_patologia_fk FOREIGN KEY (id_patologia) REFERENCES patologias(id);
ALTER TABLE P_S ADD CONSTRAINT ps_persona_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE P_S ADD CONSTRAINT ps_sintoma_fk FOREIGN KEY (id_sintoma) REFERENCES sintomas(id);
ALTER TABLE P_PROV ADD CONSTRAINT pprov_persona_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE P_PROV ADD CONSTRAINT pprov_prov_fk FOREIGN KEY (id_proveedor) REFERENCES proveedores(id);
ALTER TABLE infectados_covid ADD CONSTRAINT inf_persona_fk FOREIGN KEY (id_persona) REFERENCES personas(id);
ALTER TABLE infectados_covid ADD CONSTRAINT inf_estado_fk FOREIGN KEY (id_estado) REFERENCES estados(id);
ALTER TABLE infectados_covid ADD CONSTRAINT inf_hist_trat_fk FOREIGN KEY (id_hist_trat) REFERENCES historico_tratamiento(id); 
