/* TDA'S */
CREATE OR REPLACE TYPE covid_data AS OBJECT (
    poblacion number, -- NOT NULL
    MEMBER FUNCTION numero_infectados (id_valor NUMBER,parametro varchar2) RETURN NUMBER,--done
    MEMBER FUNCTION numero_fallecidos (id_valor NUMBER,parametro varchar2) RETURN NUMBER,--done
    MEMBER FUNCTION numero_recuperados (id_valor NUMBER,parametro varchar2) RETURN NUMBER,--done
    MEMBER FUNCTION porcentaje_infectados (id_estado NUMBER) RETURN NUMBER,--done
    MEMBER FUNCTION porcentaje_fallecidos (id_estado NUMBER) RETURN NUMBER,--done
    MEMBER FUNCTION porcentaje_recuperados (id_estado NUMBER) RETURN NUMBER--done
);
/
CREATE OR REPLACE TYPE persona AS OBJECT (
    img     BLOB,
    nom1    VARCHAR(15) , --NOT NULL
    nom2    VARCHAR(15),
    ape1    VARCHAR(15) , --NOT NULL
    ape2    VARCHAR(15) ,  --NOT NULL
    fec_nac DATE , --NOT NULL
    fec_mue DATE,
    genero  VARCHAR(2) ,  --NOT NULL
    MEMBER FUNCTION edad (fec_nac DATE) RETURN NUMBER
    -- MEMBER FUNCTION size_of_img (img BLOB) RETURN NUMBER
);
/
CREATE OR REPLACE TYPE BODY persona AS
MEMBER FUNCTION edad (fec_nac IN date) return number
IS res number(4);
BEGIN
    IF fec_nac>SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Fecha de nacimiento no puede ser superior a la fecha actual');
    ELSE 
        res := MONTHS_BETWEEN(sysdate, fec_nac) / 12;
        return(res);
    END IF;
END;
END;

/
CREATE OR REPLACE TYPE historia AS OBJECT (
    fec_i DATE ,  --NOT NULL
    fec_f DATE,
    MEMBER FUNCTION comprobar_fechas (fec_i DATE, fec_f DATE) RETURN integer
);
/
CREATE OR REPLACE TYPE BODY historia AS
MEMBER FUNCTION comprobar_fechas (fec_i IN date,fec_f IN date) return integer
IS res number(4);
BEGIN
    IF fec_i>fec_f THEN
        RAISE_APPLICATION_ERROR(-20001, 'Fecha de inicio no puede ser superior a la fecha final');
        return 0;
    ELSE 
        return 1;
    END IF;
END;
END;