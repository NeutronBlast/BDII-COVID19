-- Report 7
CREATE OR REPLACE PROCEDURE REPORTE_7 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, PAIS IN VARCHAR2, FECHA_INICIO IN DATE, FECHA_FIN IN DATE)
IS 
BEGIN
    IF PAIS IS NOT NULL THEN 
        OPEN ORACLE_REF_CURSOR FOR 
        SELECT a.img as "AEROLINEA", 
        v.n_vuelo as "Nº VUELO", 
        po.bandera as "DESDE", pd.bandera as "HASTA",
        eo.nom as "ESTADO ORIGEN", ed.nom as "ESTADO DESTINO",
        v.hist.fec_i as "FECHA INICIO", v.hist.fec_f as "FECHA FIN",
        p.id as "ID PASAJERO", p.pers.img as "FOTO", p.pers.nom1 as "PRIMER NOMBRE", NVL(p.pers.nom2, ' ') as "SEGUNDO NOMBRE", p.pers.ape1 as "PRIMER APELLIDO", p.pers.ape2 as "SEGUNDO APELLIDO"
        FROM PERSONAS p 
        JOIN P_HV phv ON phv.id_persona = p.id 
        JOIN HISTORICO_VIAJES v ON v.id = phv.id_viaje
        JOIN AEROLINEAS a ON a.id = v.id_aero
        JOIN ESTADOS eo ON eo.id = v.id_estado_1
        JOIN PAISES po ON po.id = eo.id_pais
        JOIN ESTADOS ed ON ed.id = v.id_estado_2
        JOIN PAISES pd ON pd.id = ed.id_pais
        WHERE pd.nom LIKE INITCAP(PAIS)
        AND v.hist.fec_i >= TO_DATE(TO_CHAR(FECHA_INICIO, 'DD-MM-YYYY'), 'DD-MM-YYYY')
        AND v.hist.fec_f <= TO_DATE(TO_CHAR(FECHA_FIN, 'DD-MM-YYYY'), 'DD-MM-YYYY')
        ORDER BY v.hist.fec_i;

    ELSE 
        OPEN ORACLE_REF_CURSOR FOR 
        SELECT a.img as "AEROLINEA", 
        v.n_vuelo as "Nº VUELO", 
        po.bandera as "DESDE", pd.bandera as "HASTA",
        eo.nom as "ESTADO ORIGEN", ed.nom as "ESTADO DESTINO",
        v.hist.fec_i as "FECHA INICIO", v.hist.fec_f as "FECHA FIN",
        p.id as "ID PASAJERO", p.pers.img as "FOTO", p.pers.nom1 as "PRIMER NOMBRE", NVL(p.pers.nom2, ' ') as "SEGUNDO NOMBRE", p.pers.ape1 as "PRIMER APELLIDO", p.pers.ape2 as "SEGUNDO APELLIDO"
        FROM PERSONAS p 
        JOIN P_HV phv ON phv.id_persona = p.id 
        JOIN HISTORICO_VIAJES v ON v.id = phv.id_viaje
        JOIN AEROLINEAS a ON a.id = v.id_aero
        JOIN ESTADOS eo ON eo.id = v.id_estado_1
        JOIN PAISES po ON po.id = eo.id_pais
        JOIN ESTADOS ed ON ed.id = v.id_estado_2
        JOIN PAISES pd ON pd.id = ed.id_pais
        WHERE v.hist.fec_i >= TO_DATE(TO_CHAR(FECHA_INICIO, 'DD-MM-YYYY'), 'DD-MM-YYYY')
        AND v.hist.fec_f <= TO_DATE(TO_CHAR(FECHA_FIN, 'DD-MM-YYYY'), 'DD-MM-YYYY')
        ORDER BY v.hist.fec_i;
        END IF;
END;