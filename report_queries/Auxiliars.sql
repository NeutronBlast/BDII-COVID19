-- Visitas

CREATE OR REPLACE FUNCTION VISITAS(viaje number) RETURN VARCHAR2 IS
CURSOR visit_values IS 
    SELECT c.nom
    FROM C_HV chv
    JOIN CIUDADES c ON c.id = chv.id_ciudad
    WHERE id_viaje = viaje;

v_name ciudades.nom%type;
v_output VARCHAR2(1500);
BEGIN
    BEGIN
    OPEN visit_values;
    FETCH visit_values INTO v_name;
    WHILE visit_values%FOUND

    LOOP
        IF v_output IS NULL THEN
            v_output := v_name;
        ELSE 
            v_output:= v_output || ' - ' || v_name;
        END IF;
        FETCH visit_values INTO v_name;
    END LOOP;

    CLOSE visit_values;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.put_line('No se encontro ningun dato'||SQLERRM);
    END;

    RETURN (v_output);
END;

-- Poblacion

CREATE OR REPLACE FUNCTION POBLACION_PAIS (in_pais NUMBER) RETURN NUMBER IS
resultado number;
BEGIN
    BEGIN 
        SELECT 
        SUM(e.data.poblacion)
        INTO resultado
        FROM ESTADOS e
        WHERE e.id_pais = in_pais;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line('No se encontro ningun dato'||SQLERRM);
    END;

    RETURN (resultado);
END;