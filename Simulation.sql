-- De acuerdo al modelo la cadena de infeccion ira de la siguiente forma:
--  1. Si es modelo de libre movilidad cada persona infectada con covid-19 infectara entre 0 y 3 personas mas (random)
--  2. Si es modelo de cuarentena una de cada 16 personas tendra 1/16 de probabilidad de ser infectado de covid-19
--  3. El modelo dejara de iterar cuando se llegue a la fecha fin
--  4. Se registraran los infectados en la tabla infectados-covid
--  5. Modelo 1 = Libre movilidad
--  6. Modelo 2 = Cuarentena
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
poblacion number;
total_people number;
random_person number;
random_interval number;
random_ns number; -- Numero de sintomas que se pondran
random_s number; -- Sintoma aleatorio
s_exists number; -- Verifica si el sintoma ya existe o no
is_infected number; 
cont_s number; -- Contador para loop interno de insertar sintomas
cont number; -- Contador para loop interno de infectar personas con coronita
cont_externo number; -- Contador de loop externo para saber por cuantos infectados infectare mas gente por coronita
BEGIN
    -- Cadena de infeccion para libre movilidad
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

    --Seleccionar el numero total de personas en el estado asi tengo todos los ids disponibles para el random
    SELECT COUNT(*) 
    INTO total_people
    FROM PERSONAS p
    JOIN CALLES ca ON ca.id = p.id_calle
    JOIN URBANIZACIONES u ON u.id = ca.id_urb
    JOIN CIUDADES c ON c.id = u.id_ciudad
    JOIN ESTADOS e ON e.id = c.id_estado
    WHERE e.id = in_estado; 

    --Poblacion en el estado
    SELECT e.data.poblacion
    INTO poblacion
    FROM estados e WHERE e.id = in_estado;

    --DBMS_OUTPUT.PUT_LINE('Iterador'|| i ||' Personas disponibles '||total_people ||' Poblacion estado ' || poblacion);


    LOOP
        cont:=0;
        --Infectados en el estado
        SELECT COUNT(*)
        INTO num_infectados
        FROM INFECTADOS_COVID i
        JOIN estados e ON e.id = in_estado  
        WHERE i.estado = 'I';


        --El numero random que salga sera el numero de personas que seran infectadas de covid-19

        IF in_modelo = 1 THEN --Libre movilidad
        max_random_infected := TRUNC(DBMS_RANDOM.value(0,4));
        ELSE max_random_infected := TRUNC(DBMS_RANDOM.value(0,1)); -- Cuarentena
        END IF;

        --Inicializar para evitar error en el LOOP interno
        is_infected:= 1;

        --Infectar con coronita de 0 a 3 personas
        LOOP
            random_person:= TRUNC(DBMS_RANDOM.value(1, total_people));

            --Verificar si la persona es infectable
            --Para que una persona sea infectable debe ocurrir lo siguiente
            --1. No puede estar muerto
            --2. No puede estar infectado previamente
            --3. Debe vivir en el estado seleccionado
            BEGIN
            SELECT COUNT(p.id)
            INTO is_infected
            FROM PERSONAS p
            JOIN CALLES ca ON ca.id = p.id_calle
            JOIN URBANIZACIONES u ON u.id = ca.id_urb
            JOIN CIUDADES c ON c.id = u.id_ciudad
            JOIN ESTADOS e ON e.id = c.id_estado
            JOIN INFECTADOS_COVID i ON i.id_persona = p.id
            WHERE e.id = in_estado AND p.id = random_person AND i.hist.fec_f IS NULL;
            -- Si no encuentra nada 
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN is_infected := NULL;
            END;

            random_interval := TRUNC(DBMS_RANDOM.value(0,11)); -- Intervalo de infeccion

            --No se hace loop hasta que haya un infectable por si acaso toda la gente del estado se llegara a infectar
            --Si la persona seleccionada no se puede infectar trataremos de infectar a un viajero
            IF is_infected <> 0 THEN
                -- Seleccionar viajero al azar para infectar
                BEGIN
                SELECT COUNT(*)
                INTO is_infected
                FROM (SELECT p.id FROM personas p
                JOIN historico_viajes h ON h.id_estado_2 = in_estado
                JOIN P_HV phv ON phv.id_persona = p.id AND phv.id_viaje = h.id
                WHERE NOT EXISTS (
                SELECT id FROM infectados_covid i WHERE id_persona = p.id AND i.hist.fec_f IS NULL
                ) AND h.hist.fec_i BETWEEN fecha_i AND fecha_f
                ORDER BY DBMS_RANDOM.RANDOM);

                IF is_infected <> 0 THEN
                    SELECT id
                    INTO random_person
                    FROM (SELECT p.id FROM personas p
                    JOIN historico_viajes h ON h.id_estado_2 = in_estado
                    JOIN P_HV phv ON phv.id_persona = p.id AND phv.id_viaje = h.id
                    WHERE NOT EXISTS (
                    SELECT id FROM infectados_covid i WHERE id_persona = p.id AND i.hist.fec_f IS NULL
                    ) AND h.hist.fec_i BETWEEN fecha_i AND fecha_f
                    ORDER BY DBMS_RANDOM.RANDOM)
                    WHERE ROWNUM = 1;
                END IF;

                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN random_person := NULL;
                END;
                
                --DBMS_OUTPUT.PUT_LINE('Por aqui: ' || random_person);

                    IF is_infected <> 0 THEN
                    -- Por cada infectado por coronita insertamos un numero aleatorio de sintomas
                        INSERT INTO infectados_covid VALUES (id_infectado_seq.nextval, historia((SELECT (SYSDATE + cont_externo + random_interval) FROM DUAL),
                        null), 'I', random_person, null, in_estado);
                        cont_s:= 0;
                        random_ns:= TRUNC(DBMS_RANDOM.value(1,5));                        
                        -- Insertar sintomas
                        LOOP
                        random_s:= TRUNC(DBMS_RANDOM.value(0,19));
                        SELECT COUNT (*)
                        INTO s_exists
                        FROM P_S p
                        WHERE p.id_persona = random_person AND p.id_sintoma = random_s AND TO_CHAR(p.fec_i, 'DD-MM-YYYY') = TO_DATE((SELECT (SYSDATE + cont_externo) FROM DUAL));

                        -- Si no esta repetido, insertar
                        IF s_exists = 0 THEN
                        INSERT INTO P_S VALUES (random_person, random_s, (SELECT (SYSDATE + cont_externo) FROM DUAL));
                        cont_s:=cont_s+1;
                        END IF;

                        EXIT WHEN cont_s > random_ns;
                        END LOOP;
                    END IF;

            ELSE
                INSERT INTO infectados_covid VALUES (id_infectado_seq.nextval, historia((SELECT (SYSDATE + cont_externo + random_interval) FROM DUAL),
                null), 'I', random_person, null, in_estado);

                cont_s:= 0;
                random_ns:= TRUNC(DBMS_RANDOM.value(1,5));                        
                -- Insertar sintomas
                LOOP
                    random_s:= TRUNC(DBMS_RANDOM.value(0,19));
                    SELECT COUNT (*)
                    INTO s_exists
                    FROM P_S p
                    WHERE p.id_persona = random_person AND p.id_sintoma = random_s AND TO_CHAR(p.fec_i, 'DD-MM-YYYY') = TO_DATE((SELECT (SYSDATE + cont_externo) FROM DUAL));

                    -- Si no esta repetido, insertar
                    IF s_exists = 0 THEN
                    INSERT INTO P_S VALUES (random_person, random_s, (SELECT (SYSDATE + cont_externo) FROM DUAL));
                    cont_s:=cont_s+1;
                    END IF;

                    EXIT WHEN cont_s > random_ns;
                    END LOOP;
            END IF;

            cont:=cont+1;
            EXIT WHEN cont > max_random_infected;
        END LOOP;

        cont_externo:=cont_externo+1;

        EXIT WHEN cont_externo = i OR num_infectados = total_people;
        END LOOP;
END;

-- Se saca el 15% del total de infectados con round
-- Se coloca un rango de (0, 15%) y cada dia que pase ese numero aleatorio ira al hospital (ciclico)
-- Lo mismo aplica para las muertes pero en vez de 15% sera 5%

CREATE OR REPLACE PROCEDURE DESTINO (in_estado number, fecha_i date, fecha_f date) IS 
i number; -- Iterador
num_infectados number; -- Numero de infectados en el estado
ftp number; -- 15%
fp number; -- 5%
hospital_victims number;
death_victims number;
cont_externo number;
cont_h number; -- Contador para personas que requeriran atencion
random_person number;
BEGIN
    -- Numero de iteraciones
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

    --15% Infectados en el estado
    SELECT ROUND(COUNT(*)*0.15)
    INTO ftp
    FROM INFECTADOS_COVID i
    JOIN estados e ON e.id = in_estado 
    WHERE i.estado = 'I';

    --5% Infectados en el estado
    SELECT ROUND(COUNT(*)*0.05)
    INTO fp
    FROM INFECTADOS_COVID i
    JOIN estados e ON e.id = in_estado 
    WHERE i.estado = 'I';

    LOOP
    hospital_victims:= ROUND(DBMS_RANDOM.value(0,ftp));
    cont_h:=0;
        LOOP
        
        -- La persona debe ser hospitalizable, para que esto ocurra se debe cumplir lo siguiente:
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

        cont_h:=cont_h+1;
        EXIT WHEN cont_h = hospital_victims;
        END LOOP;

    cont_externo:=cont_externo+1;
    EXIT WHEN cont_externo = i 
    END LOOP;
END;

