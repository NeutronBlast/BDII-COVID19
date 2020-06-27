CREATE OR REPLACE PROCEDURE REPORTE_4 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, PAIS IN NUMBER, ESTADO IN NUMBER) IS 
BEGIN
    IF PAIS = 0 OR ESTADO = 0 THEN 
        IF PAIS = 0 AND ESTADO <> 0 THEN
            OPEN ORACLE_REF_CURSOR FOR
            SELECT p.bandera as "Pais", TO_CHAR(POBLACION_PAIS(p.id)) || ' habitantes' as "Poblacion Pais", e.nom || ' - ' || p.nom as "Estado", e.data.numero_infectados(e.id, 'E') as "Infectados",
            TO_CHAR(ROUND(e.data.numero_infectados(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Infectados",
            e.data.numero_fallecidos(e.id, 'E') as "Fallecidos", TO_CHAR(ROUND(e.data.numero_fallecidos(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Fallecidos", e.data.numero_recuperados(e.id, 'E') as "Recuperados",
            TO_CHAR(ROUND(e.data.numero_recuperados(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Recuperados"
            FROM ESTADOS e 
            JOIN PAISES p ON p.id = e.id_pais
            WHERE e.id = ESTADO;
        END IF;

        IF PAIS <> 0 AND ESTADO = 0 THEN 
            OPEN ORACLE_REF_CURSOR FOR
            SELECT p.bandera as "Pais", TO_CHAR(POBLACION_PAIS(PAIS)) || ' habitantes' as "Poblacion Pais", e.nom || ' - ' || p.nom as "Estado", e.data.numero_infectados(e.id, 'E') as "Infectados",
            TO_CHAR(ROUND(e.data.numero_infectados(e.id, 'E')*100/
            POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Infectados",
            e.data.numero_fallecidos(e.id, 'E') as "Fallecidos", TO_CHAR(ROUND(e.data.numero_fallecidos(e.id, 'E')*100/
            POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Fallecidos", e.data.numero_recuperados(e.id, 'E') as "Recuperados",
            TO_CHAR(ROUND(e.data.numero_recuperados(e.id, 'E')*100/
            POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Recuperados"
            FROM ESTADOS e 
            JOIN PAISES p ON p.id = e.id_pais
            WHERE e.id_pais = PAIS;
        END IF;

        IF PAIS = 0 AND ESTADO = 0 THEN 
            OPEN ORACLE_REF_CURSOR FOR
            SELECT p.bandera as "Pais", TO_CHAR(POBLACION_PAIS(p.id)) || ' habitantes' as "Poblacion Pais", e.nom || ' - ' || p.nom as "Estado", e.data.numero_infectados(e.id, 'E') as "Infectados",
            TO_CHAR(ROUND(e.data.numero_infectados(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Infectados",
            e.data.numero_fallecidos(e.id, 'E') as "Fallecidos", TO_CHAR(ROUND(e.data.numero_fallecidos(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Fallecidos", e.data.numero_recuperados(e.id, 'E') as "Recuperados",
            TO_CHAR(ROUND(e.data.numero_recuperados(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Recuperados"
            FROM ESTADOS e 
            JOIN PAISES p ON p.id = e.id_pais;
        END IF;

    ELSE 
    OPEN ORACLE_REF_CURSOR FOR
    SELECT p.bandera as "Pais", TO_CHAR(POBLACION_PAIS(PAIS)) || ' habitantes' as "Poblacion Pais", e.nom || ' - ' || p.nom as "Estado", e.data.numero_infectados(e.id, 'E') as "Infectados",
    TO_CHAR(ROUND(e.data.numero_infectados(e.id, 'E')*100/
    POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Infectados",
    e.data.numero_fallecidos(e.id, 'E') as "Fallecidos", TO_CHAR(ROUND(e.data.numero_fallecidos(e.id, 'E')*100/
    POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Fallecidos", e.data.numero_recuperados(e.id, 'E') as "Recuperados",
    TO_CHAR(ROUND(e.data.numero_recuperados(e.id, 'E')*100/
    POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Recuperados"
    FROM ESTADOS e 
    JOIN PAISES p ON p.id = e.id_pais
    WHERE e.id_pais = PAIS AND e.id = ESTADO;
    END IF;
END;

CREATE OR REPLACE PROCEDURE REPORTE_5 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, PAIS IN NUMBER) IS 
BEGIN

    IF PAIS <> 0 THEN 
    OPEN ORACLE_REF_CURSOR FOR 
        SELECT p.bandera as "Pais", h.hist.fec_i as "Fecha de Inicio", NVL(h.hist.fec_f, to_date('31/12/2020', 'DD-MM-YYYY')) as "Fecha Fin", 
        'Modelo ' || m.id || ' - ' || m.nom as "Modelo"
        FROM historico_modelos h 
        JOIN estados e ON e.id = h.id_estado
        JOIN paises p ON p.id = e.id_pais
        JOIN modelos m ON m.id = h.id_modelo
        WHERE p.id = PAIS
        ORDER BY h.hist.fec_i;
    ELSE 
        OPEN ORACLE_REF_CURSOR FOR 
        SELECT p.bandera as "Pais", h.hist.fec_i as "Fecha de Inicio", NVL(h.hist.fec_f, to_date('31/12/2020', 'DD-MM-YYYY')) as "Fecha Fin", 
        'Modelo ' || m.id || ' - ' || m.nom as "Modelo"
        FROM historico_modelos h 
        JOIN estados e ON e.id = h.id_estado
        JOIN paises p ON p.id = e.id_pais
        JOIN modelos m ON m.id = h.id_modelo
        ORDER BY p.id;
    END IF;
END;