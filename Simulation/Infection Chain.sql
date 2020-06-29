-- De acuerdo al modelo la cadena de infeccion ira de la siguiente forma:
--  1. Si es modelo de libre movilidad cada persona infectada con covid-19 infectara entre 0 y 3 personas mas (random)
--  2. Si es modelo de cuarentena una de cada 16 personas tendra 1/16 de probabilidad de ser infectado de covid-19
--  3. El modelo dejara de iterar cuando se llegue a la fecha fin
--  4. Se registraran los infectados en la tabla infectados-covid
--  5. Modelo 1 = Libre movilidad
--  6. Modelo 2 = Cuarentena
CREATE OR REPLACE PROCEDURE CADENA_INFECCION (in_modelo number, in_estado number, fecha_i date, fecha_f date)
IS
i number; -- Numero de dias que voy a iterar
num_infectados number;
max_random_infected number;
random_person number;
random_ns number; -- Numero de sintomas que se pondran
random_s number; -- Sintoma aleatorio
cont_s number; -- Contador para loop interno de insertar sintomas
cont number; -- Contador para loop interno de infectar personas con coronita
cont_externo number; -- Contador de loop externo para saber por cuantos infectados infectare mas gente por coronita
-- Valores output
nombre personas.pers.nom1%type;
apellido personas.pers.ape1%type;
fecha_infeccion date;
BEGIN
    -- Cadena de infeccion para libre movilidad
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

    LOOP
        cont:=0;
        --El numero random que salga sera el numero de personas que seran infectadas de covid-19

        IF in_modelo = 1 THEN --Libre movilidad
        max_random_infected := ROUND(DBMS_RANDOM.value(0,4));
            ELSE max_random_infected := ROUND(DBMS_RANDOM.value(0,1), 0); -- Cuarentena
        END IF;

        --Infectar con coronita de 0 a 3 personas
        IF max_random_infected > 0 THEN 
        LOOP
            --Para que una persona sea infectable debe ocurrir lo siguiente
            --1. No puede estar muerto
            --2. No puede estar infectado previamente
            --3. Debe vivir en el estado seleccionado o haber viajado al estado seleccionado en el intervalo de tiempo donde se aplique el modelo
            
            BEGIN
            SELECT id 
            INTO random_person
            FROM (SELECT p.id FROM PERSONAS p
            JOIN CALLES c ON c.id = p.id_calle
            JOIN URBANIZACIONES u ON u.id = c.id_urb
            JOIN CIUDADES ci ON ci.id = u.id_ciudad
            JOIN ESTADOS e ON e.id = ci.id_estado
            WHERE (e.id = in_estado OR EXISTS (
                SELECT * 
                FROM P_HV phv
                JOIN historico_viajes v ON v.id = phv.id_viaje
                WHERE v.id_estado_2 = in_estado AND phv.id_persona = p.id AND v.hist.fec_i BETWEEN fecha_i AND fecha_f AND v.hist.fec_i BETWEEN fecha_i AND fecha_f
            )) AND NOT EXISTS (
                SELECT * FROM INFECTADOS_COVID i WHERE i.id_persona = p.id AND i.hist.fec_f IS NULL
            )
            ORDER BY DBMS_RANDOM.RANDOM
            )
            WHERE ROWNUM = 1;

            EXCEPTION 
                WHEN NO_DATA_FOUND THEN random_person := 0;
            END;

            --No se hace loop hasta que haya un infectable por si acaso toda la gente del estado se llegara a infectar
            --Si la persona seleccionada no se puede infectar trataremos de infectar a un viajero
            IF random_person <> 0 THEN

                SELECT p.pers.nom1, p.pers.ape1
                INTO nombre, apellido
                FROM personas p
                WHERE p.id = random_person;

                fecha_infeccion:=fecha_i+cont_externo;

                DBMS_OUTPUT.PUT_LINE('Se infecto: ' || nombre || ' ' || apellido || ' el dia ' || fecha_infeccion );

                -- Por cada infectado por coronita insertamos un numero aleatorio de sintomas
                INSERT INTO infectados_covid VALUES (id_infectado_seq.nextval, historia(fecha_i,
                null), 'I', random_person, null, in_estado);
                
                cont_s:= 0;
                random_ns:= TRUNC(DBMS_RANDOM.value(1,5));                        
                -- Insertar sintomas
                LOOP
                    BEGIN
                    SELECT id
                    INTO random_s 
                    FROM (SELECT s.id FROM sintomas s 
                    WHERE NOT EXISTS (
                        SELECT * FROM P_S ps WHERE ps.id_persona = random_person AND ps.id_sintoma = s.id AND (ps.fec_i IS NULL OR ps.fec_i BETWEEN fecha_i AND fecha_f)
                    )
                    ORDER BY DBMS_RANDOM.RANDOM
                    )
                    WHERE ROWNUM = 1;

                    EXCEPTION 
                        WHEN NO_DATA_FOUND THEN random_s := 0;
                    END;
                    -- Si no esta repetido, insertar
                    IF random_s <> 0 THEN
                        INSERT INTO P_S VALUES (random_person, random_s, fecha_i + cont_externo);
                    cont_s:=cont_s+1;
                    END IF;

                EXIT WHEN cont_s > random_ns;
                END LOOP;
            END IF;

            cont:=cont+1;
            EXIT WHEN cont = max_random_infected;
        END LOOP;
        END IF; -- Si el iterador es mayor a 0

        cont_externo:=cont_externo+1;
        EXIT WHEN cont_externo = i;
        END LOOP;

        INSERT INTO historico_modelos VALUES (id_hist_modelo_seq.nextval, historia(fecha_i, fecha_f), in_estado, in_modelo);
END;

-- Aqui se decide quien va al hospital y quien muere
/
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
-- Valores output
nombre personas.pers.nom1%type;
apellido personas.pers.ape1%type;
hospital recintos_salud.nom%type;
fecha_h date;
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
        BEGIN
        SELECT id
        INTO random_person
        FROM (SELECT p.id FROM personas p
        JOIN INFECTADOS_COVID i ON i.id_persona = p.id
        JOIN ESTADOS e ON e.id = in_estado
        WHERE i.estado = 'I' AND 
        NOT EXISTS (SELECT h.id_persona FROM historico_tratamiento h WHERE h.id_persona = p.id AND h.hist.fec_f IS NULL)
        AND i.hist.fec_f IS NULL
        ORDER BY DBMS_RANDOM.VALUE)
        WHERE ROWNUM = 1;
    
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN random_person:= 0;
        END;

        IF random_person > 0 THEN
            IF hospital_victim < 0.40 AND hospital_victim > 0.10 THEN
            -- Si hay personas hospitalizables se hospitalizara alguna al azar

            --Seleccionar recinto de salud al azar ubicado en el mismo estado que no este colapsado
            --Para que no este colapsado debe cumplir lo siguiente
            --1. Suficientes camas
            --2. Suficientes insumos
                BEGIN 
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

                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN hospital_id:= 0;
                END;
            
            IF hospital_id > 0 THEN 
            --Seleccionar fecha donde empezo la infeccion
                SELECT i.hist.fec_i
                INTO infection_date
                FROM INFECTADOS_COVID i
                WHERE i.id_persona = random_person
                AND i.hist.fec_f IS NULL;

                hospital_date_interval:= TRUNC(DBMS_RANDOM.VALUE(5,21));

                -- Output
                SELECT p.pers.nom1, p.pers.ape1
                INTO nombre, apellido
                FROM personas p
                WHERE p.id = random_person;

                SELECT r.nom
                INTO hospital
                FROM recintos_salud r
                WHERE r.id = hospital_id;

                fecha_h:=infection_date + hospital_date_interval;
                
                DBMS_OUTPUT.PUT_LINE('La persona ' || nombre || ' ' || apellido || ' fue enviada al hospital ' || hospital || ' el dia ' || fecha_h);

                INSERT INTO historico_tratamiento VALUES (id_hist_tratamiento_seq.nextval, historia(infection_date + hospital_date_interval, null), random_person, hospital_id); 
            END IF; 
            END IF; -- Chance

            -- Kill
            IF hospital_victim < 0.1 THEN

            -- La persona debe ser asesinable, para que esto ocurra se debe cumplir lo siguiente:
            -- 1. La persona seleccionada puede o no estar en el hospital ya
            -- 2. No puede estar muerta
            -- 3. Debe estar infectada

            -- Si hay personas asesinables se asesinara alguna al azar

                BEGIN 
                SELECT id
                INTO random_person
                FROM (SELECT p.id FROM personas p
                JOIN INFECTADOS_COVID i ON i.id_persona = p.id
                JOIN ESTADOS e ON e.id = in_estado
                WHERE i.estado = 'I' AND i.hist.fec_f IS NULL
                ORDER BY DBMS_RANDOM.VALUE)
                WHERE ROWNUM = 1;

                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN random_person:= 0;
                END;

                IF random_person > 0 THEN 
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

            -- Output
                SELECT p.pers.nom1, p.pers.ape1
                INTO nombre, apellido
                FROM personas p
                WHERE p.id = random_person;

                fecha_h:=hospital_date + hospital_date_interval;
                
                DBMS_OUTPUT.PUT_LINE('La persona ' || nombre || ' ' || apellido || ' murio el dia ' || fecha_h);

            END IF; -- Si hay personas hospitalizables

            END IF; -- Chance

        -- Si no cae en la muerte u hospital entonces sera recuperado
        IF hospital_victim > 0.40 THEN 
        -- La persona debe ser recuperable, para que esto ocurra se debe cumplir lo siguiente:
            -- 1. La persona seleccionada puede o no estar en el hospital ya
            -- 2. No puede estar muerta
            -- 3. Debe estar infectada

            -- Si hay personas recuperables se recuperara alguna al azar
            
                BEGIN
                SELECT id
                INTO random_person
                FROM (SELECT p.id FROM personas p
                JOIN INFECTADOS_COVID i ON i.id_persona = p.id
                JOIN ESTADOS e ON e.id = in_estado
                WHERE i.estado = 'I' AND i.hist.fec_f IS NULL
                ORDER BY DBMS_RANDOM.VALUE)
                WHERE ROWNUM = 1;

                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN random_person:= 0;
                END;

            IF random_person > 0 THEN 
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

                    UPDATE infectados_covid i SET i.estado = 'R', i.hist.fec_f = i.hist.fec_i + hospital_date_interval WHERE id_persona = random_person;
                
                ELSE 
                -- Seleccionar fecha de infeccion
                    SELECT i.hist.fec_i
                    INTO hospital_date
                    FROM infectados_covid i
                    WHERE i.id_persona = random_person AND i.hist.fec_f IS NULL;
                    
                    hospital_date_interval:= TRUNC(DBMS_RANDOM.VALUE(5,21));

                -- Actualizar estatus
                    UPDATE infectados_covid i SET i.estado = 'R', i.hist.fec_f = i.hist.fec_i + hospital_date_interval WHERE id_persona = random_person;
                END IF; -- If de si fue hospitalizado antes o no
                END IF; -- Si esta en el hospital
            
            -- Output
                SELECT p.pers.nom1, p.pers.ape1
                INTO nombre, apellido
                FROM personas p
                WHERE p.id = random_person;

                fecha_h:=hospital_date + hospital_date_interval;
                
                DBMS_OUTPUT.PUT_LINE('La persona ' || nombre || ' ' || apellido || ' se recupero el dia ' || fecha_h);
            END IF; -- Si es recuperable
        END IF; -- Diferente de NULL

    cont_externo:=cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP;
END;