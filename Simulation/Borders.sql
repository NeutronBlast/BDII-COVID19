CREATE OR REPLACE PROCEDURE CONTROL_FRONTERAS (fecha_i date, fecha_f date)
IS
i number; -- Iterador
cont_externo number; 
BEGIN
-- Numero de iteraciones
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

    LOOP
        SELECT (
            SELECT p.id, COUNT (*)
            FROM PAISES p
            JOIN ESTADOS e ON e.id_pais = p.id 
            JOIN CIUDADES c ON c.id_estado = e.id 
            JOIN URBANIZACIONES u ON u.id_ciudad = c.id
            JOIN CALLES ca ON ca.id_urb = u.id 
            JOIN PERSONAS pe ON pe.id_calle = ca.id 
            GROUP BY p.id
            ORDER BY p.id;
        )/(SELECT (
            SELECT SUM ((SELECT COUNT(*) FROM INFECTADOS_COVID A 
            JOIN estados e on e.id = p.id
            WHERE A.id_estado=e.id AND A.estado = 'I'))
            FROM DUAL
            )
            FROM PAISES p
            WHERE p.id = 1;)
        
    cont_externo:= cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP; 
END;