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