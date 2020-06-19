/* TDA'S */
CREATE OR REPLACE TYPE covid_data AS OBJECT (
    poblacion number, -- NOT NULL
    STATIC FUNCTION numero_infectados (id_pais NUMBER) RETURN NUMBER,--done
    STATIC FUNCTION numero_fallecidos (id_pais NUMBER) RETURN NUMBER,--done
    STATIC FUNCTION numero_recuperados (id_pais NUMBER) RETURN NUMBER,--done
    STATIC FUNCTION porcentaje_infectados (id_pais NUMBER) RETURN NUMBER,--done
    STATIC FUNCTION porcentaje_fallecidos (id_pais NUMBER) RETURN NUMBER,--done
    STATIC FUNCTION porcentaje_recuperados (id_pais NUMBER) RETURN NUMBER--done
    -- STATIC FUNCTION porcentaje_infectados (pob NUMBER, infec NUMBER) RETURN NUMBER,
    -- STATIC FUNCTION porcentaje_fallecidos (pob NUMBER, infec NUMBER, fall NUMBER) RETURN NUMBER,
    -- STATIC FUNCTION porcentaje_recuperados (pob NUMBER, infec NUMBER, recup NUMBER) RETURN NUMBER
);
/
--numeros infectados
CREATE OR REPLACE TYPE BODY covid_data AS MEMBER FUNCTION numero_infectados(id_pais IN number) RETURN number
IS resultado number;
BEGIN
    resultado:= SELECT COUNT(*) FROM INFECCIONES A WHERE A.id_pais=id_pais AND A.estado = "infectado";
    return resultado; 
END;
--numero fallecidos
CREATE OR REPLACE TYPE BODY covid_data AS MEMBER FUNCTION numero_fallecidos(id_pais IN number) RETURN number
IS resultado number;
BEGIN
    resultado:= SELECT COUNT(*) FROM INFECCIONES A WHERE A.id_pais=id_pais AND A.estado = "muerto";
    return resultado; 
END;
--numero recuperados
CREATE OR REPLACE TYPE BODY covid_data AS MEMBER FUNCTION numero_recuperados(id_pais IN number) RETURN number
IS resultado number;
BEGIN
    resultado:= SELECT COUNT(*) FROM INFECCIONES A WHERE A.id_pais=id_pais AND A.estado = "curado";
    return resultado; 
END;

--porcentaje_infectados
CREATE OR REPLACE TYPE BODY covid_data AS MEMBER FUNCTION porcentaje_infectados(id_pais IN number) RETURN number
IS resultado number;
poblacion number;
BEGIN
    poblacion:= SELECT SUM(A.poblacion) FROM ESTADO A WHERE A.id_pais = id_pais; 
    resultado:= SELECT COUNT(*) FROM INFECCIONES A WHERE A.id_pais=id_pais AND A.estado = "infectado";
    return ROUND(resultado*100/poblacion,2); 
END;
--porcentaje_recuperados
CREATE OR REPLACE TYPE BODY covid_data AS MEMBER FUNCTION porcentaje_recuperados(id_pais IN number) RETURN number
IS resultado number;
poblacion number;
BEGIN
    total_casos:= SELECT COUNT(*) FROM INFECCIONES A WHERE A.id_pais=id_pais;
    recuperados:= SELECT COUNT(*) FROM INFECCIONES A WHERE A.id_pais=id_pais AND A.estado = "curado";
    return ROUND(recuperados*100/total_casos,2); 
END;
--porcentaje_fallecidos
CREATE OR REPLACE TYPE BODY covid_data AS MEMBER FUNCTION porcentaje_recuperados(id_pais IN number) RETURN number
IS resultado number;
poblacion number;
BEGIN
    total_casos:= SELECT COUNT(*) FROM INFECCIONES A WHERE A.id_pais=id_pais;
    fallecidos:= SELECT COUNT(*) FROM INFECCIONES A WHERE A.id_pais=id_pais AND A.estado = "muerto";
    return ROUND(fallecidos*100/total_casos,2); 
END;

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
/
CREATE OR REPLACE TYPE historia AS OBJECT (
    fec_i DATE ,  --NOT NULL
    fec_f DATE,
    STATIC FUNCTION comprobar_fechas (fec_i DATE, fec_f DATE) RETURN NUMBER
);