CREATE OR REPLACE PROCEDURE DESTINO (in_estado number, fecha_i date, fecha_f date) IS 
i number; -- Iterador
num_infectados number; -- Numero de infectados en el estado
hospital_victim number; -- 15% chance;
death_victim number; -- 5% chance;
cont_externo number;
random_person number;
is_killable number;
is_in_hospital number;
infection_date date;
hospital_date date;
hospital_date_interval number;
hospital_id number;
BEGIN
    -- Numero de iteraciones
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

    LOOP
    hospital_victim:= DBMS_RANDOM.value(0,1); 

        -- La persona debe ser hospitalizable o recuperable, para que esto ocurra se debe cumplir lo siguiente:
        -- 1. La persona seleccionada no debe estar en el hospital ya
        -- 2. No puede estar muerta
        -- 3. Debe estar infectada

        SELECT id
        INTO random_person
        FROM (SELECT p.id FROM personas p
        JOIN INFECTADOS_COVID i ON i.id_persona = p.id
        JOIN ESTADOS e ON e.id = in_estado
        WHERE i.estado = 'I' AND 
        NOT EXISTS (SELECT h.id_persona FROM historico_tratamiento h WHERE h.id_persona = p.id AND h.hist.fec_f IS NULL)
        ORDER BY DBMS_RANDOM.VALUE)
        WHERE ROWNUM = 1;

        IF hospital_victim < 0.30 AND hospital_victim > 0.10 THEN
        -- Si hay personas hospitalizables se hospitalizara alguna al azar
            SELECT COUNT(*)
            INTO is_killable
            FROM (SELECT p.id FROM personas p
            JOIN INFECTADOS_COVID i ON i.id_persona = p.id
            JOIN ESTADOS e ON e.id = in_estado
            WHERE i.estado = 'I' AND 
            NOT EXISTS (SELECT h.id_persona FROM historico_tratamiento h WHERE h.id_persona = p.id AND h.hist.fec_f IS NULL)
            ORDER BY DBMS_RANDOM.VALUE);

        IF is_killable <> 0 THEN

        --Seleccionar recinto de salud al azar ubicado en el mismo estado que no este colapsado
            SELECT id
            INTO hospital_id
            FROM (SELECT r.id FROM recintos_salud r 
            JOIN calles c ON c.id = r.id_calle
            JOIN urbanizaciones u ON u.id = c.id_urb
            JOIN ciudades ci ON ci.id = u.id_ciudad
            JOIN estados e ON e.id = ci.id_estado
            WHERE e.id = in_estado AND r.n_camas > (
                SELECT COUNT(*) FROM historico_tratamiento h WHERE h.hist.fec_f IS NOT NULL AND h.id_rec_salud = r.id 
            )
            ORDER BY DBMS_RANDOM.VALUE)
            WHERE ROWNUM = 1;

        --Seleccionar fecha donde empezo la infeccion
            SELECT i.hist.fec_i
            INTO infection_date
            FROM INFECTADOS_COVID i
            WHERE i.id_persona = random_person;

            hospital_date_interval:= TRUNC(DBMS_RANDOM.VALUE(5,21));

            INSERT INTO historico_tratamiento VALUES (id_hist_tratamiento_seq.nextval, historia(infection_date + hospital_date_interval, null), random_person, hospital_id); 
        END IF;
        END IF; -- 15% chance

        -- Kill
        IF hospital_victim < 0.1 THEN

        -- La persona debe ser asesinable, para que esto ocurra se debe cumplir lo siguiente:
        -- 1. La persona seleccionada puede o no estar en el hospital ya
        -- 2. No puede estar muerta
        -- 3. Debe estar infectada

        SELECT COUNT(*)
        INTO is_killable
        FROM (SELECT p.id FROM personas p
        JOIN INFECTADOS_COVID i ON i.id_persona = p.id
        JOIN ESTADOS e ON e.id = in_estado
        WHERE i.estado = 'I'
        ORDER BY DBMS_RANDOM.VALUE);

        -- Si hay personas asesinables se asesinara alguna al azar
        IF is_killable <> 0 THEN
            SELECT id
            INTO random_person
            FROM (SELECT p.id FROM personas p
            JOIN INFECTADOS_COVID i ON i.id_persona = p.id
            JOIN ESTADOS e ON e.id = in_estado
            WHERE i.estado = 'I'
            ORDER BY DBMS_RANDOM.VALUE)
            WHERE ROWNUM = 1;

        -- Seleccionar si esta persona ya esta en el hospital
            SELECT COUNT(*)
            INTO is_in_hospital
            FROM historico_tratamiento h 
            WHERE h.hist.fec_f IS NULL AND h.id_persona = random_person;

        --Seleccionar fecha donde fue hospitalizado
            IF is_in_hospital <> 0 THEN
            SELECT i.hist.fec_i
            INTO hospital_date
            FROM historico_tratamiento i
            WHERE i.id_persona = random_person AND i.hist.fec_f IS NULL;

            hospital_date_interval:= TRUNC(DBMS_RANDOM.VALUE(5,21));

        -- Actualizar estatus
            UPDATE historico_tratamiento h SET h.hist.fec_f = h.hist.fec_i + hospital_date_interval
            WHERE h.id_persona = random_person AND h.hist.fec_f IS NULL;

            UPDATE infectados_covid SET estado = 'M' WHERE id_persona = random_person;

            UPDATE personas p SET p.pers.fec_mue = hospital_date + hospital_date_interval
            WHERE id = random_person;
            ELSE 
            -- Seleccionar fecha de infeccion
                SELECT i.hist.fec_i
                INTO hospital_date
                FROM infectados_covid i
                WHERE i.id_persona = random_person AND i.hist.fec_f IS NULL;
                
                hospital_date_interval:= TRUNC(DBMS_RANDOM.VALUE(5,21));

            -- Actualizar estatus
                UPDATE infectados_covid SET estado = 'M' WHERE id_persona = random_person;

                UPDATE personas p SET p.pers.fec_mue = hospital_date + hospital_date_interval
                WHERE id = random_person;
            END IF; -- If de si fue hospitalizado antes o no
        END IF; -- If de si es asesinable

    END IF; -- 10% chance

    -- Si no cae en la muerte u hospital entonces sera recuperado
    IF hospital_victim > 0.30 THEN 
       -- La persona debe ser recuperable, para que esto ocurra se debe cumplir lo siguiente:
        -- 1. La persona seleccionada puede o no estar en el hospital ya
        -- 2. No puede estar muerta
        -- 3. Debe estar infectada

        SELECT COUNT(*)
        INTO is_killable
        FROM (SELECT p.id FROM personas p
        JOIN INFECTADOS_COVID i ON i.id_persona = p.id
        JOIN ESTADOS e ON e.id = in_estado
        WHERE i.estado = 'I'
        ORDER BY DBMS_RANDOM.VALUE);

        -- Si hay personas recuperables se recuperara alguna al azar
        IF is_killable <> 0 THEN
            SELECT id
            INTO random_person
            FROM (SELECT p.id FROM personas p
            JOIN INFECTADOS_COVID i ON i.id_persona = p.id
            JOIN ESTADOS e ON e.id = in_estado
            WHERE i.estado = 'I'
            ORDER BY DBMS_RANDOM.VALUE)
            WHERE ROWNUM = 1;

        -- Seleccionar si esta persona ya esta en el hospital
            SELECT COUNT(*)
            INTO is_in_hospital
            FROM historico_tratamiento h 
            WHERE h.hist.fec_f IS NULL AND h.id_persona = random_person;

        --Seleccionar fecha donde fue hospitalizado
            IF is_in_hospital <> 0 THEN
            SELECT i.hist.fec_i
            INTO hospital_date
            FROM historico_tratamiento i
            WHERE i.id_persona = random_person AND i.hist.fec_f IS NULL;

            hospital_date_interval:= TRUNC(DBMS_RANDOM.VALUE(5,21));

        -- Actualizar estatus
            UPDATE historico_tratamiento h SET h.hist.fec_f = h.hist.fec_i + hospital_date_interval
            WHERE h.id_persona = random_person AND h.hist.fec_f IS NULL;

            UPDATE infectados_covid SET estado = 'R' WHERE id_persona = random_person;
            ELSE 
            -- Seleccionar fecha de infeccion
                SELECT i.hist.fec_i
                INTO hospital_date
                FROM infectados_covid i
                WHERE i.id_persona = random_person AND i.hist.fec_f IS NULL;
                
                hospital_date_interval:= TRUNC(DBMS_RANDOM.VALUE(5,21));

            -- Actualizar estatus
                UPDATE infectados_covid SET estado = 'R' WHERE id_persona = random_person;
            END IF; -- If de si fue hospitalizado antes o no
        END IF; -- If de si es recuperable
    END IF;
    cont_externo:=cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP;
END;

