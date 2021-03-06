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
/
-- Report 8
CREATE OR REPLACE PROCEDURE REPORTE_8 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR)
IS
BEGIN 
OPEN ORACLE_REF_CURSOR FOR  
    SELECT c.nom || ', ' || u.nom || ', ' || ci.nom || ', ' || e.nom || ', ' || p.nom as "DIRECCION",
    r.nom as "CLINICA", CONCAT_INSUMO(r.id) as "INSUMOS DISPONIBLES",
    NVL(r.n_camas-t.ocupado, r.n_camas) as "CAMAS DISPONIBLES",
    r.datos.numero_infectados(r.id, 'RS') as "ATENDIDOS", r.datos.numero_fallecidos(r.id, 'RS') as "FALLECIDOS",
    r.datos.numero_recuperados(r.id, 'RS') as "RECUPERADOS"
    FROM recintos_salud r
    JOIN calles c ON c.id = r.id_calle
    JOIN urbanizaciones u ON u.id = c.id_urb
    JOIN ciudades ci ON ci.id = u.id_ciudad
    JOIN estados e ON e.id = ci.id_estado
    JOIN paises p ON p.id = e.id_pais
    LEFT JOIN (
        SELECT ht.id_rec_salud, COUNT(*) as ocupado FROM historico_tratamiento ht 
        WHERE ht.hist.fec_f IS NULL  
        GROUP BY ht.id_rec_salud
    )t ON t.id_rec_salud = r.id;
END;
/

-- Report 9
CREATE OR REPLACE PROCEDURE REPORTE_9 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, PAIS IN VARCHAR2)
IS 
BEGIN
    IF PAIS IS NOT NULL THEN 
    OPEN ORACLE_REF_CURSOR FOR 
    SELECT p.bandera as "PAIS QUE OFRECE LA AYUDA", pr.bandera as "PAIS RECEPTOR",
    a.hist.fec_i as "FECHA DE DONACION", CONCAT_AYUDA_INSUMO(a.id) as "INSUMOS DONADOS",
    (SELECT TO_CHAR(10000,'L99G999D99MI',
    'NLS_NUMERIC_CHARACTERS = '',.''
    NLS_CURRENCY = ''$'' ') "DINERO"
        FROM DUAL) as "DINERO"
    FROM historico_ayuda_humanitaria a 
    JOIN paises p ON p.id = a.id_pais_1 -- Envia
    JOIN paises pr ON pr.id = a.id_pais_2 -- Recibe
    WHERE pr.nom LIKE INITCAP(PAIS); 
    
    ELSE 
    OPEN ORACLE_REF_CURSOR FOR 
    SELECT p.bandera as "PAIS QUE OFRECE LA AYUDA", pr.bandera as "PAIS RECEPTOR",
    a.hist.fec_i as "FECHA DE DONACION", CONCAT_AYUDA_INSUMO(a.id) as "INSUMOS DONADOS",
    (SELECT TO_CHAR(10000,'L99G999D99MI',
    'NLS_NUMERIC_CHARACTERS = '',.''
    NLS_CURRENCY = ''$'' ') "DINERO"
        FROM DUAL) as "DINERO"
    FROM historico_ayuda_humanitaria a 
    JOIN paises p ON p.id = a.id_pais_1 -- Envia
    JOIN paises pr ON pr.id = a.id_pais_2; -- Recibe
    END IF;
END;
/

-- Reporte 10
CREATE OR REPLACE PROCEDURE REPORTE_10 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, PAIS IN VARCHAR2)
IS 
BEGIN
    IF PAIS IS NOT NULL THEN 
    OPEN ORACLE_REF_CURSOR FOR 
    SELECT p.bandera as "PAIS",
    m.nom as "MODELO",
    hm.hist.fec_i as "FECHA DE INICIO",
    ROUND((recuperados_modelo (hm.hist.fec_i, hm.hist.fec_f, e.id)/NVL(NULLIF(infectados_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id)+recuperados_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id)+fallecidos_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id),0),1)-
    fallecidos_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id)/NVL(NULLIF(infectados_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id)+recuperados_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id)+fallecidos_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id),0),1))*100) || '%' as "PORCENTAJE DE EFECTIVIDAD"
    FROM historico_modelos hm 
    JOIN modelos m ON m.id = hm.id_modelo
    JOIN estados e ON e.id = hm.id_estado
    JOIN paises p ON p.id = e.id_pais
    WHERE p.nom LIKE INITCAP(PAIS)
    ORDER BY hm.hist.fec_i;

    ELSE 
    OPEN ORACLE_REF_CURSOR FOR 
    SELECT p.bandera as "PAIS",
    m.nom as "MODELO",
    hm.hist.fec_i as "FECHA DE INICIO",
    ROUND((recuperados_modelo (hm.hist.fec_i, hm.hist.fec_f, e.id)/NVL(NULLIF(infectados_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id)+recuperados_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id)+fallecidos_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id),0),1)-
    fallecidos_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id)/NVL(NULLIF(infectados_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id)+recuperados_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id)+fallecidos_modelo(hm.hist.fec_i, hm.hist.fec_f, e.id),0),1))*100) || '%' as "PORCENTAJE DE EFECTIVIDAD"
    FROM historico_modelos hm 
    JOIN modelos m ON m.id = hm.id_modelo
    JOIN estados e ON e.id = hm.id_estado
    JOIN paises p ON p.id = e.id_pais
    ORDER BY hm.hist.fec_i;
    END IF;
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
                GROUP BY p.nom,pr.nom,pp.hist.fec_i;
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
                GROUP BY p.nom,pr.nom,pp.hist.fec_i;
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
                GROUP BY p.nom,pr.nom,pp.hist.fec_i;
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
                GROUP BY p.nom,pr.nom,pp.hist.fec_i;
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