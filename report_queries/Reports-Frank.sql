-- Reporte 3

-- Query

CREATE OR REPLACE PROCEDURE REPORTE_3 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, FECHA_INICIO IN DATE, FECHA_FIN IN DATE) IS 
BEGIN
    OPEN ORACLE_REF_CURSOR FOR 
        SELECT p.id AS "Nª Id", p.pers.img AS "Foto", p.pers.nom1 as "Primer Nombre", NVL(p.pers.nom2, ' ') AS "Segundo Nombre",
        p.pers.ape1 as "Primer Apellido", p.pers.ape2 as "Segundo Apellido", p.pers.edad(p.pers.fec_nac)
        AS "Edad", pa.bandera as "Pais de residencia", pv.bandera as "Pais donde viajo", TO_CHAR(h.hist.fec_i, 'DD/MM/YYYY') AS "Fecha de inicio del viaje",
        TO_CHAR(h.hist.fec_f, 'DD/MM/YYYY') AS "Fecha de fin de viaje", visitas(h.id) AS "Lugares donde visito"
        FROM PERSONAS p
        JOIN CALLES c ON c.id = p.id_calle
        JOIN URBANIZACIONES u ON u.id = c.id_urb
        JOIN CIUDADES ci ON ci.id = u.id_ciudad
        JOIN ESTADOS e ON e.id = ci.id_estado
        JOIN PAISES pa ON pa.id = e.id_pais
        -- Join viaje
        JOIN P_HV phv ON phv.id_persona = p.id
        JOIN historico_viajes h ON h.id = phv.id_viaje
        JOIN ESTADOS ev ON ev.id = h.id_estado_2
        JOIN PAISES pv ON pv.id = ev.id_pais
        WHERE h.hist.fec_i BETWEEN FECHA_INICIO AND FECHA_FIN
        AND h.hist.fec_f BETWEEN FECHA_INICIO AND FECHA_FIN
        ORDER BY h.hist.fec_i;
END;

