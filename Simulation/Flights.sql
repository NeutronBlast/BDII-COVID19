CREATE OR REPLACE PROCEDURE VUELOS (fecha_i date, fecha_f date)
IS
i number; -- Iterador
cont_externo number; 
random_person number;
random_country number;
random_state number;
random_airline number;
current_flight number;
travels number; -- 30% de probabilidad de viajar
countries number;
airlines number;
flight_n number;
end_of_travel number; -- Fecha de fin para viaje generado
BEGIN
-- Numero de iteraciones
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

    -- Numero de paises que no tienen frontera cerrada
    SELECT COUNT(*) into countries FROM PAISES p
    WHERE NOT EXISTS (
        SELECT f.id FROM historico_cierre_fronteras f WHERE f.id_pais = p.id
        AND (f.hist.fec_i BETWEEN fecha_i AND fecha_f OR f.hist.fec_f BETWEEN fecha_i AND fecha_f)
    );

    -- Numero de aerolineas
    SELECT COUNT(*) into airlines FROM AEROLINEAS;

    LOOP
    -- Seleccionar persona al azar que no este viajando durante el intervalo especificado
    BEGIN
    SELECT id 
    INTO random_person
    FROM (SELECT
    p.id FROM
    PERSONAS p
    WHERE NOT EXISTS (
    SELECT * FROM P_HV phv 
    JOIN historico_viajes hv ON hv.id = phv.id_viaje
    WHERE phv.id_persona = p.id AND hv.hist.fec_i BETWEEN fecha_i AND fecha_f)
    ORDER BY DBMS_RANDOM.VALUE)
    WHERE ROWNUM = 1;
    
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN random_person := 0;
    END;

    IF random_person <> 0 THEN
        travels:= DBMS_RANDOM.VALUE(0,1);

            IF travels < 0.40 THEN
                --Seleccionar pais al azar que no tenga frontera cerrada
                SELECT id 
                INTO random_country
                FROM
                (SELECT p.id
                FROM PAISES p
                WHERE NOT EXISTS (
                    SELECT f.id FROM historico_cierre_fronteras f WHERE f.id_pais = p.id 
                    AND (f.hist.fec_i BETWEEN fecha_i AND fecha_f OR
                    f.hist.fec_f BETWEEN fecha_i AND fecha_f)
                )
                ORDER BY DBMS_RANDOM.RANDOM
                )
                WHERE ROWNUM = 1;

                --Seleccionar un estado aleatorio de ese pais
                SELECT id 
                INTO random_state
                FROM
                (
                    SELECT e.id 
                    FROM ESTADOS e
                    WHERE e.id_pais = random_country
                    ORDER BY DBMS_RANDOM.RANDOM
                )
                WHERE ROWNUM = 1;

                --Seleccionar aerolinea al azar
                SELECT id 
                INTO random_airline
                FROM
                (
                    SELECT a.id 
                    FROM AEROLINEAS a
                    ORDER BY DBMS_RANDOM.RANDOM
                )
                WHERE ROWNUM = 1;

                -- Registrar viaje
                end_of_travel:= ROUND(DBMS_RANDOM.VALUE(10,30));
                flight_n:= ROUND(DBMS_RANDOM.VALUE(100, 300));

                INSERT INTO historico_viajes VALUES (id_hist_viajes_seq.nextval, historia((SELECT (SYSDATE + cont_externo) FROM DUAL), (SELECT (SYSDATE + cont_externo + end_of_travel) FROM DUAL)), flight_n, random_airline, (
                    SELECT e.id FROM personas p
                    JOIN calles c ON c.id = p.id_calle
                    JOIN urbanizaciones u ON u.id = c.id_urb
                    JOIN ciudades ci ON ci.id = u.id_ciudad
                    JOIN estados e ON e.id = ci.id_estado
                    WHERE p.id = random_person
                ), random_state);

                SELECT h.id
                INTO current_flight
                FROM historico_viajes h 
                WHERE h.hist.fec_i = (SELECT (SYSDATE + cont_externo) FROM DUAL)
                AND h.hist.fec_f = (SELECT (SYSDATE + cont_externo + end_of_travel) FROM DUAL)
                AND n_vuelo = flight_n
                AND id_aero = random_airline;

                INSERT INTO P_HV VALUES (current_flight, random_person);

            END IF;
    END IF;
    
    cont_externo:= cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP; 
END;