-- Reporte 3
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
/
-- Reporte 4
CREATE OR REPLACE PROCEDURE REPORTE_4 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, PAIS IN NUMBER, ESTADO IN NUMBER) IS 
BEGIN
    OPEN ORACLE_REF_CURSOR FOR
    SELECT p.bandera as "Pais", TO_CHAR(POBLACION_PAIS(PAIS)) || ' habitantes' as "Poblacion Pais", e.nom || ' - ' || p.nom as "Estado", e.data.numero_infectados(e.id, 'E') as "Infectados",
    TO_CHAR(ROUND(e.data.numero_infectados(e.id, 'E')*100/
    POBLACION_PAIS(PAIS), 10)) || '%' as "Porcentaje Infectados",
    e.data.numero_fallecidos(e.id, 'E') as "Fallecidos", TO_CHAR(ROUND(e.data.numero_fallecidos(e.id, 'E')*100/
    POBLACION_PAIS(PAIS), 10)) || '%' as "Porcentaje Fallecidos", e.data.numero_recuperados(e.id, 'E') as "Recuperados",
    TO_CHAR(ROUND(e.data.numero_recuperados(e.id, 'E')*100/
    POBLACION_PAIS(PAIS), 10)) || '%' as "Porcentaje Recuperados"
    FROM ESTADOS e 
    JOIN PAISES p ON p.id = e.id_pais
    WHERE e.id_pais = PAIS AND e.id = ESTADO;
END;

/

-- Reporte 5
CREATE OR REPLACE PROCEDURE REPORTE_5 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, PAIS IN NUMBER) IS 
BEGIN
    OPEN ORACLE_REF_CURSOR FOR 
        SELECT p.bandera as "Pais", h.hist.fec_i as "Fecha de Inicio", NVL(h.hist.fec_f, to_date('31/12/2020', 'DD-MM-YYYY')) as "Fecha Fin", 
        'Modelo ' || m.id || ' - ' || m.nom as "Modelo"
        FROM historico_modelos h 
        JOIN estados e ON e.id = h.id_estado
        JOIN paises p ON p.id = e.id_pais
        JOIN modelos m ON m.id = h.id_modelo
        WHERE p.id = PAIS
        ORDER BY h.hist.fec_i;
END;

/

-- Reporte 6
CREATE OR REPLACE PROCEDURE REPORTE_6(ORACLE_REF_CURSOR OUT SYS_REFCURSOR, FECHA_INICIO IN DATE, FECHA_FIN IN DATE,num_pais IN NUMBER) IS
BEGIN
    OPEN ORACLE_REF_CURSOR FOR
        SELECT p.nom,p.bandera,(SELECT COUNT(*) FROM infectados_covid a 
                JOIN ESTADOS e ON a.id_estado = e.id
                JOIN PAISES p ON e.id_pais = p.id
                WHERE p.id = num_pais AND a.estado = 'I' AND (a.hist.fec_i BETWEEN FECHA_INICIO AND i.hist.fec_i)) as "infectados",
                i.hist.fec_i as "Fecha"
                FROM infectados_covid i 
                JOIN ESTADOS e ON i.id_estado = e.id
                JOIN PAISES p ON e.id_pais = p.id
                WHERE p.id = num_pais AND i.estado = 'I' AND (i.hist.fec_i BETWEEN FECHA_INICIO AND FECHA_FIN) ORDER BY i.hist.fec_i asc;
END;