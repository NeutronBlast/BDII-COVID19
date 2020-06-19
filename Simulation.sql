-- De acuerdo al modelo la cadena de infeccion ira de la siguiente forma:
--  1. Si es modelo de libre movilidad cada persona infectada con covid-19 infectara entre 0 y 3 personas mas (random)
--  2. Si es modelo de cuarentena una de cada 16 personas tendra 1/16 de probabilidad de ser infectado de covid-19
--  3. El modelo dejara de iterar cuando se llegue a la fecha fin
--  4. Se registraran los infectados en la tabla infectados-covid
--  5. Modelo 1 = Libre movilidad
--  6. Modelo 2 = Cuarentena
CREATE OR REPLACE PROCEDURE CADENA_INFECCION (id_modelo number, id_estado number, fecha_i date, fecha_f date)
IS
num_infectados number;
max_random_infected number;
poblacion number;
total_people number;
random_person number;
is_infected number; 
BEGIN
    -- Cadena de infeccion para libre movilidad
    IF id_modelo = 1 THEN

        --Infectados en el estado
        SELECT COUNT(*) FROM INFECTADOS_COVID i
        JOIN estados e ON e.id = id_estado 
        WHERE i.estado = 'I'
        INTO num_infectados;

        --Poblacion en el estado
        SELECT e.data.poblacion FROM estados e WHERE e.id = id_estado
        INTO poblacion e;
        
        --Este sera el rango maximo para hacer el random
        IF num_infectados*3 >= poblacion THEN
            max_random_infected:=poblacion;
        ELSE
            max_random_infected:=num_infectados*3;
        END IF;

        --El numero random que salga sera el numero de personas que seran infectadas de covid-19
        max_random_infected := DBMS_RANDOM.value(0,max_random_infected);

        --Seleccionar el numero total de personas en el estado asi tengo todos los ids disponibles para el random
        SELECT COUNT(*) FROM PERSONAS p
        JOIN URBANIZACIONES u ON u.id = p.id_calle
        JOIN CIUDADES c ON c.id = u.id_ciudad
        JOIN ESTADOS e ON e.id = c.id_estado
        INTO total_people; 
        
        --Inicializar para evitar error en el LOOP
        is_infected:= 1;

        --Infectar con coronita
        LOOP
        random_person:= DBMS_RANDOM.value(1, total_people);

        --Verificar si la persona es infectable
        --Para que una persona sea infectable debe ocurrir lo siguiente
        --1. No puede estar muerto
        --2. No puede estar infectado previamente
        --3. Debe vivir en el estado seleccionado

        SELECT p.id FROM PERSONAS p
        JOIN URBANIZACIONES u ON u.id = p.id_calle
        JOIN CIUDADES c ON c.id = u.id_ciudad
        JOIN ESTADOS e ON e.id = c.id_estado
        WHERE EXISTS (SELECT * FROM INFECTADOS_COVID i WHERE i.id_persona = p.id 
        AND i.historia.fecha_f IS NOT NULL) AND p.id = random_person
        INTO is_infected; 

        EXIT WHEN is_infected = NULL;
        END LOOP;

        INSERT INTO infectados_covid (i.id_infectado_seq.nextval, i.historia((SELECT SYSDATE FROM DUAL),
        null), 'I', random_person, null, id_estado);
    END IF;

    -- Cadena de infeccion para cuarentena
    ELSE IF id_modelo = 2 THEN
    END IF;
END;