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
flight_n number;
end_of_travel number; -- Fecha de fin para viaje generado
-- Valores output
nombre personas.pers.nom1%type;
apellido personas.pers.ape1%type;
pais paises.nom%type;
estado estados.nom%type;
aerolinea aerolineas.nom%type;
vuelo historico_viajes.n_vuelo%type;
fecha_v date;
BEGIN
-- Numero de iteraciones
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

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

                INSERT INTO historico_viajes VALUES (id_hist_viajes_seq.nextval, historia(fecha_i + cont_externo, fecha_f + end_of_travel), flight_n, random_airline, (
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
                WHERE h.hist.fec_i = fecha_i + cont_externo
                AND h.hist.fec_f = fecha_f + end_of_travel
                AND h.n_vuelo = flight_n
                AND h.id_aero = random_airline;

                -- Output
                SELECT p.pers.nom1, p.pers.ape1
                INTO nombre, apellido
                FROM personas p
                WHERE p.id = random_person;

                SELECT p.nom, e.nom
                INTO pais, estado
                FROM estados e 
                JOIN paises p ON p.id = e.id_pais
                WHERE e.id = random_state;

                SELECT h.n_vuelo, a.nom 
                INTO vuelo, aerolinea
                FROM historico_viajes h 
                JOIN aerolineas a ON a.id = h.id_aero
                WHERE h.id = current_flight;

                fecha_v:=fecha_i + cont_externo;

                DBMS_OUTPUT.PUT_LINE('La persona ' || nombre || ' ' || apellido || ' viajo a ' ||
                estado || ' - ' || pais || ' en el vuelo Nº ' || vuelo || ' de ' || aerolinea ||
                ' el dia ' || fecha_v);

                INSERT INTO P_HV VALUES (current_flight, random_person);
            END IF;
    END IF;
    
    cont_externo:= cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP; 
END;