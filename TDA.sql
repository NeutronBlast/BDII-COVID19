/* TDA'S */
CREATE OR REPLACE TYPE covid_data AS OBJECT (
    poblacion number, -- NOT NULL
    STATIC FUNCTION numero_infectados (id_pais NUMBER) RETURN NUMBER,
    STATIC FUNCTION numero_fallecidos (id_pais NUMBER) RETURN NUMBER,
    STATIC FUNCTION numero_recuperados (id_pais NUMBER) RETURN NUMBER,
    STATIC FUNCTION porcentaje_infectados (pob NUMBER, infec NUMBER) RETURN NUMBER,
    STATIC FUNCTION porcentaje_fallecidos (pob NUMBER, infec NUMBER, fall NUMBER) RETURN NUMBER,
    STATIC FUNCTION porcentaje_recuperados (pob NUMBER, infec NUMBER, recup NUMBER) RETURN NUMBER
);
--Los not null en objetos se verifican con un check en el create table
CREATE OR REPLACE TYPE persona AS OBJECT (
    img     BLOB,
    nom1    VARCHAR(15) , --NOT NULL
    nom2    VARCHAR(15),
    ape1    VARCHAR(15) , --NOT NULL
    ape2    VARCHAR(15) ,  --NOT NULL
    fec_nac DATE , --NOT NULL
    fec_mue DATE,
    genero  VARCHAR(2) ,  --NOT NULL
    STATIC FUNCTION edad (fec_nac DATE) RETURN NUMBER,
    STATIC FUNCTION size_of_img (img BLOB) RETURN NUMBER
);

CREATE OR REPLACE TYPE historia AS OBJECT (
    fec_i DATE ,  --NOT NULL
    fec_f DATE,
    STATIC FUNCTION comprobar_fechas (fec_i DATE, fec_f DATE) RETURN NUMBER
);