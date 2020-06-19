-- De acuerdo al modelo la cadena de infeccion ira de la siguiente forma:
--  1. Si es modelo de libre movilidad cada persona infectada con covid-19 infectara entre 0 y 3 personas mas (random)
--  2. Si es modelo de cuarentena una de cada 16 personas tendra 1/16 de probabilidad de ser infectado de covid-19
--  3. El modelo dejara de iterar cuando se llegue a la fecha fin
--  4. Se registraran los infectados en la tabla infectados-covid
--  5. Modelo 1 = Libre movilidad
--  6. Modelo 2 = Cuarentena
CREATE OR REPLACE PROCEDURE CADENA_INFECCION_LM (id_estado number, fecha_i date, fecha_f date)
IS
i number; -- Numero de dias que voy a iterar
num_infectados number;
max_random_infected number;
poblacion number;
total_people number;
random_person number;
is_infected number; 
cont number; -- Contador para loop interno de infectar personas con coronita
cont_externo number; -- Contador de loop externo para saber por cuantos infectados infectare mas gente por coronita
BEGIN
    -- Cadena de infeccion para libre movilidad
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_f
    INTO i
    FROM dual;

    --Seleccionar el numero total de personas en el estado asi tengo todos los ids disponibles para el random
    SELECT COUNT(*) 
    INTO total_people
    FROM PERSONAS p
    JOIN URBANIZACIONES u ON u.id = p.id_calle
    JOIN CIUDADES c ON c.id = u.id_ciudad
    JOIN ESTADOS e ON e.id = c.id_estado; 

    --Poblacion en el estado
    SELECT e.data.poblacion
    INTO poblacion
    FROM estados e WHERE e.id = id_estado;

    LOOP
        cont:=0;
        --Infectados en el estado
        SELECT COUNT(*)
        INTO num_infectados
        FROM INFECTADOS_COVID i
        JOIN estados e ON e.id = id_estado 
        WHERE i.estado = 'I';

        --El numero random que salga sera el numero de personas que seran infectadas de covid-19
        max_random_infected := DBMS_RANDOM.value(0,3);
        
        --Inicializar para evitar error en el LOOP interno
        is_infected:= 1;

        --Infectar con coronita de 0 a 3 personas
        LOOP
            random_person:= DBMS_RANDOM.value(1, total_people);

            --Verificar si la persona es infectable
            --Para que una persona sea infectable debe ocurrir lo siguiente
            --1. No puede estar muerto
            --2. No puede estar infectado previamente
            --3. Debe vivir en el estado seleccionado

            SELECT p.id
            INTO is_infected
            FROM PERSONAS p
            JOIN URBANIZACIONES u ON u.id = p.id_calle
            JOIN CIUDADES c ON c.id = u.id_ciudad
            JOIN ESTADOS e ON e.id = c.id_estado
            WHERE EXISTS (SELECT * FROM INFECTADOS_COVID i WHERE i.id_persona = p.id 
            AND i.hist.fec_f IS NOT NULL AND ROWNUM = 1) AND p.id = random_person; 

            --No se hace loop hasta que haya un infectable por si acaso toda la gente del estado se llegara a infectar
            --Si la persona seleccionada no se puede infectar trataremos de infectar a un viajero
            IF is_infected = NULL THEN
                SELECT p.id
                INTO is_infected
                FROM PERSONAS p 
                JOIN historico_viajes h ON h.id_estado_2 = id_estado AND h.hist.fec_i BETWEEN fecha_i AND fecha_f AND h.hist.fec_f >= fecha_f
                JOIN P_HV phv ON phv.id_viaje = h.id
                WHERE NOT EXISTS (SELECT * FROM INFECTADOS_COVID i WHERE i.id_persona = p.id AND i.hist.fec_f IS NOT NULL AND ROWNUM = 1);

                IF is_infected <> NULL THEN
                    INSERT INTO infectados_covid VALUES (id_infectado_seq.nextval, historia((SELECT SYSDATE FROM DUAL),
                    null), 'I', is_infected, null, id_estado);
                END IF; 
            ELSE
                INSERT INTO infectados_covid VALUES (id_infectado_seq.nextval, historia((SELECT SYSDATE FROM DUAL),
                null), 'I', random_person, null, id_estado);
            END IF;

            cont:=cont+1;
            EXIT WHEN cont > max_random_infected;
        END LOOP;

        cont_externo:=cont_externo+1;
        EXIT WHEN cont_externo = i OR num_infectados = total_people;
        END LOOP;
END;