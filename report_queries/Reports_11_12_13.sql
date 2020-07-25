--aux POBLACION MUNDIAL
CREATE OR REPLACE FUNCTION TOTAL_POBLACION RETURN NUMBER
AS
    CURSOR v_cursor IS
        SELECT e.data.poblacion FROM estados e;

    v_acumulado NUMBER;
    v_poblacion NUMBER;
    
BEGIN 
    OPEN v_cursor;
    FETCH v_cursor INTO v_poblacion;
    v_acumulado := 0;
    WHILE v_cursor%FOUND
    LOOP
        v_acumulado := v_acumulado + v_poblacion;
        FETCH v_cursor INTO v_poblacion;
    END LOOP;
    CLOSE v_cursor;
    return (v_acumulado);
END;
/
-- Report 11
CREATE OR REPLACE PROCEDURE REPORTE_11 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, FECHA_INICIO IN DATE)
IS 
    nro_inf NUMBER;
    nro_fal NUMBER;
    nro_rec NUMBER;
BEGIN   
    IF FECHA_INICIO IS NOT NULL THEN 
        SELECT count(*) INTO nro_inf FROM infectados_covid ic WHERE ic.estado = 'I' AND FECHA_INICIO < ic.hist.fec_i;
        SELECT count(*) INTO nro_fal FROM infectados_covid ic WHERE ic.estado = 'M' AND FECHA_INICIO < ic.hist.fec_i;
        SELECT count(*) INTO nro_rec FROM infectados_covid ic WHERE ic.estado = 'C' AND FECHA_INICIO < ic.hist.fec_i;

        OPEN ORACLE_REF_CURSOR FOR
            SELECT
            nro_inf AS "Cantidad de infectados",
            nro_fal AS "Cantidad de fallecidos",
            nro_rec AS "Cantidad de recuperados",
            round(nro_inf * 100 / TOTAL_POBLACION,4) AS "Porcentaje de infectados",
            round(nro_fal * 100 / TOTAL_POBLACION,4) AS "Porcentaje de fallecidos",
            round(nro_rec * 100 / TOTAL_POBLACION,4) AS "Porcentaje de recuperados"
            FROM DUAL;
    ELSE 
        SELECT count(*) INTO nro_inf FROM infectados_covid ic WHERE ic.estado = 'I';
        SELECT count(*) INTO nro_fal FROM infectados_covid ic WHERE ic.estado = 'M';
        SELECT count(*) INTO nro_rec FROM infectados_covid ic WHERE ic.estado = 'C';

        OPEN ORACLE_REF_CURSOR FOR
            SELECT
            nro_inf AS "Cantidad de infectados",
            nro_fal AS "Cantidad de fallecidos",
            nro_rec AS "Cantidad de recuperados",
            round(nro_inf * 100 / TOTAL_POBLACION,4) AS "Porcentaje de infectados",
            round(nro_fal * 100 / TOTAL_POBLACION,4) AS "Porcentaje de fallecidos",
            round(nro_rec * 100 / TOTAL_POBLACION,4) AS "Porcentaje de recuperados"
            FROM DUAL;
    END IF;
END;
/
-- Report 12
CREATE OR REPLACE PROCEDURE REPORTE_12 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, PAIS IN VARCHAR2, FECHA IN DATE)
IS
BEGIN
    IF PAIS IS NOT NULL THEN
        IF FECHA IS NOT NULL THEN
            OPEN ORACLE_REF_CURSOR FOR
                SELECT
                p.nom as "T1",
                pr.nom as "T2",
                pp.hist.fec_i as "T3",
                (select bandera from paises where nom = p.nom) AS "País",
                (select img from proveedores where nom = pr.nom) AS "Proveedor de internet",
                TO_CHAR(pp.hist.fec_i, 'DD/MM/YYYY') AS "Fecha",
                round(avg(pp.v_sub),2) AS "Velocidad promedio de subida (MB)",
                round(avg(pp.v_des),2) AS "Velocidad promedio de descarga (MB)",
                round(avg(pp.h_int),2) AS "Horas diarias de interrupcion del servicio"
                FROM paises p
                JOIN estados e ON p.id = e.id_pais
                JOIN e_p ep ON ep.id_estado = e.id
                JOIN proveedores pr ON pr.id = ep.id_proveedor
                JOIN p_prov pp ON pp.id_proveedor = ep.id_proveedor
                WHERE p.nom = PAIS AND pp.hist.fec_i <= FECHA
                GROUP BY p.nom,pr.nom,pp.hist.fec_i
                ORDER by p.nom,pr.nom,to_date("Fecha") ASC;
        ELSE
            OPEN ORACLE_REF_CURSOR FOR
                SELECT
                p.nom as "T1",
                pr.nom as "T2",
                pp.hist.fec_i as "T3",
                (select bandera from paises where nom = p.nom) AS "País",
                (select img from proveedores where nom = pr.nom) AS "Proveedor de internet",
                TO_CHAR(pp.hist.fec_i, 'DD/MM/YYYY') AS "Fecha",
                round(avg(pp.v_sub),2) AS "Velocidad promedio de subida (MB)",
                round(avg(pp.v_des),2) AS "Velocidad promedio de descarga (MB)",
                round(avg(pp.h_int),2) AS "Horas diarias de interrupcion del servicio"
                FROM paises p
                JOIN estados e ON p.id = e.id_pais
                JOIN e_p ep ON ep.id_estado = e.id
                JOIN proveedores pr ON pr.id = ep.id_proveedor
                JOIN p_prov pp ON pp.id_proveedor = ep.id_proveedor
                WHERE p.nom = PAIS
                GROUP BY p.nom,pr.nom,pp.hist.fec_i
                ORDER by p.nom,pr.nom,to_date("Fecha") ASC;
        END IF;
    ELSE
        IF FECHA IS NOT NULL THEN
            OPEN ORACLE_REF_CURSOR FOR
                SELECT
                p.nom as "T1",
                pr.nom as "T2",
                pp.hist.fec_i as "T3",
                (select bandera from paises where nom = p.nom) AS "País",
                (select img from proveedores where nom = pr.nom) AS "Proveedor de internet",
                TO_CHAR(pp.hist.fec_i, 'DD/MM/YYYY') AS "Fecha",
                round(avg(pp.v_sub),2) AS "Velocidad promedio de subida (MB)",
                round(avg(pp.v_des),2) AS "Velocidad promedio de descarga (MB)",
                round(avg(pp.h_int),2) AS "Horas diarias de interrupcion del servicio"
                FROM paises p
                JOIN estados e ON p.id = e.id_pais
                JOIN e_p ep ON ep.id_estado = e.id
                JOIN proveedores pr ON pr.id = ep.id_proveedor
                JOIN p_prov pp ON pp.id_proveedor = ep.id_proveedor
                WHERE pp.hist.fec_i <= FECHA
                GROUP BY p.nom,pr.nom,pp.hist.fec_i
                ORDER by p.nom,pr.nom,to_date("Fecha") ASC;
        ELSE
            OPEN ORACLE_REF_CURSOR FOR
                SELECT
                p.nom as "T1",
                pr.nom as "T2",
                pp.hist.fec_i as "T3",
                (select bandera from paises where nom = p.nom) AS "País",
                (select img from proveedores where nom = pr.nom) AS "Proveedor de internet",
                TO_CHAR(pp.hist.fec_i, 'DD/MM/YYYY') AS "Fecha",
                round(avg(pp.v_sub),2) AS "Velocidad promedio de subida (MB)",
                round(avg(pp.v_des),2) AS "Velocidad promedio de descarga (MB)",
                round(avg(pp.h_int),2) AS "Horas diarias de interrupcion del servicio"
                FROM paises p
                JOIN estados e ON p.id = e.id_pais
                JOIN e_p ep ON ep.id_estado = e.id
                JOIN proveedores pr ON pr.id = ep.id_proveedor
                JOIN p_prov pp ON pp.id_proveedor = ep.id_proveedor
                GROUP BY p.nom,pr.nom,pp.hist.fec_i
                ORDER by p.nom,pr.nom,to_date("Fecha") ASC;
        END IF;
    END IF;
END;
/
-- Report 13
CREATE OR REPLACE PROCEDURE REPORTE_13 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, PAIS IN VARCHAR2, FECHA_INICIO IN DATE,FECHA_FIN IN DATE)
IS 
BEGIN
    IF PAIS IS NOT NULL THEN
        IF FECHA_INICIO IS NOT NULL THEN
            IF FECHA_FIN IS NOT NULL THEN
                OPEN ORACLE_REF_CURSOR FOR
                    SELECT
                    p.bandera AS "País",
                    TO_CHAR(h.hist.fec_i, 'DD/MM/YYYY') AS "Fecha de inicio",
                    NVL(TO_CHAR(h.hist.fec_f, 'DD/MM/YYYY'), 'Actualmente cerrado') AS "Fecha de fin"
                    FROM paises p
                    JOIN historico_cierre_fronteras h ON p.id = h.id_pais
                    WHERE p.nom = PAIS AND h.hist.fec_i >= FECHA_INICIO AND h.hist.fec_f <= FECHA_FIN
                    ORDER BY h.hist.fec_i asc;
            ELSE
                OPEN ORACLE_REF_CURSOR FOR
                    SELECT
                    p.bandera AS "País",
                    TO_CHAR(h.hist.fec_i, 'DD/MM/YYYY') AS "Fecha de inicio",
                    NVL(TO_CHAR(h.hist.fec_f, 'DD/MM/YYYY'), 'Actualmente cerrado') AS "Fecha de fin"
                    FROM paises p
                    JOIN historico_cierre_fronteras h ON p.id = h.id_pais
                    WHERE p.nom = PAIS AND h.hist.fec_i >= FECHA_INICIO
                    ORDER BY h.hist.fec_i asc;
            END IF;
        ELSE
            IF FECHA_FIN IS NOT NULL THEN
                OPEN ORACLE_REF_CURSOR FOR
                    SELECT
                    p.bandera AS "País",
                    TO_CHAR(h.hist.fec_i, 'DD/MM/YYYY') AS "Fecha de inicio",
                    NVL(TO_CHAR(h.hist.fec_f, 'DD/MM/YYYY'), 'Actualmente cerrado') AS "Fecha de fin"
                    FROM paises p
                    JOIN historico_cierre_fronteras h ON p.id = h.id_pais
                    WHERE p.nom = PAIS AND h.hist.fec_f <= FECHA_FIN
                    ORDER BY h.hist.fec_i asc;
            ELSE
                OPEN ORACLE_REF_CURSOR FOR
                    SELECT
                    p.bandera AS "País",
                    TO_CHAR(h.hist.fec_i, 'DD/MM/YYYY') AS "Fecha de inicio",
                    NVL(TO_CHAR(h.hist.fec_f, 'DD/MM/YYYY'), 'Actualmente cerrado') AS "Fecha de fin"
                    FROM paises p
                    JOIN historico_cierre_fronteras h ON p.id = h.id_pais
                    WHERE p.nom = PAIS
                    ORDER BY h.hist.fec_i asc;
            END IF;
        END IF;
    ELSE 
        IF FECHA_INICIO IS NOT NULL THEN
            IF FECHA_FIN IS NOT NULL THEN
                OPEN ORACLE_REF_CURSOR FOR
                    SELECT
                    p.bandera AS "País",
                    TO_CHAR(h.hist.fec_i, 'DD/MM/YYYY') AS "Fecha de inicio",
                    NVL(TO_CHAR(h.hist.fec_f, 'DD/MM/YYYY'), 'Actualmente cerrado') AS "Fecha de fin"
                    FROM paises p
                    JOIN historico_cierre_fronteras h ON p.id = h.id_pais
                    WHERE h.hist.fec_i >= FECHA_INICIO AND h.hist.fec_f <= FECHA_FIN
                    ORDER BY h.hist.fec_i asc;
            ELSE
                OPEN ORACLE_REF_CURSOR FOR
                    SELECT
                    p.bandera AS "País",
                    TO_CHAR(h.hist.fec_i, 'DD/MM/YYYY') AS "Fecha de inicio",
                    NVL(TO_CHAR(h.hist.fec_f, 'DD/MM/YYYY'), 'Actualmente cerrado') AS "Fecha de fin"
                    FROM paises p
                    JOIN historico_cierre_fronteras h ON p.id = h.id_pais
                    WHERE h.hist.fec_i >= FECHA_INICIO
                    ORDER BY h.hist.fec_i asc;
            END IF;
        ELSE
            IF FECHA_FIN IS NOT NULL THEN
                OPEN ORACLE_REF_CURSOR FOR
                    SELECT
                    p.bandera AS "País",
                    TO_CHAR(h.hist.fec_i, 'DD/MM/YYYY') AS "Fecha de inicio",
                    NVL(TO_CHAR(h.hist.fec_f, 'DD/MM/YYYY'), 'Actualmente cerrado') AS "Fecha de fin"
                    FROM paises p
                    JOIN historico_cierre_fronteras h ON p.id = h.id_pais
                    WHERE h.hist.fec_f <= FECHA_FIN
                    ORDER BY h.hist.fec_i asc;
            ELSE
                OPEN ORACLE_REF_CURSOR FOR
                    SELECT
                    p.bandera AS "País",
                    TO_CHAR(h.hist.fec_i, 'DD/MM/YYYY') AS "Fecha de inicio",
                    NVL(TO_CHAR(h.hist.fec_f, 'DD/MM/YYYY'), 'Actualmente cerrado') AS "Fecha de fin"
                    FROM paises p
                    JOIN historico_cierre_fronteras h ON p.id = h.id_pais
                    ORDER BY h.hist.fec_i asc;
            END IF;
        END IF;
    END IF;
END;