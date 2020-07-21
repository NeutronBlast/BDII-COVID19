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
/
CREATE OR REPLACE PROCEDURE INTERNET (in_modelo number, in_estado number, fecha_i date, fecha_f date)
IS
i number; -- Iterador
cont_externo number; 
x number; 
horas number;
f_1 number; -- Factor 1
f_2 number; -- Factor 2
uso number; -- ID historico uso
new_vs number;
new_vd number;
-- Valores output
nombre personas.pers.nom1%type;
apellido personas.pers.ape1%type;
proveedor proveedores.nom%type;

CURSOR pp_values IS
SELECT id, id_persona, id_proveedor, v_sub, v_des, h_int, hist
        FROM
        (
            SELECT t.*, ROW_NUMBER() OVER (PARTITION BY t.id_persona ORDER BY t.hist.fec_i DESC) rn
            FROM P_PROV t
            JOIN PERSONAS p ON p.id = t.id_persona
            JOIN CALLES c ON c.id = p.id_calle
            JOIN URBANIZACIONES u ON u.id = c.id_urb
            JOIN CIUDADES ci ON ci.id = u.id_ciudad
            JOIN ESTADOS e ON e.id = ci.id_estado
            WHERE e.id = in_estado
        ) t
        WHERE rn = 1
        ORDER BY id_persona;
pp_reg P_PROV%rowtype;
BEGIN
    -- Numero de iteraciones
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

        IF in_modelo = 2 THEN
        -- Seleccionar registros de la tabla de uso de internet que se ubiquen en el estado especificado
            OPEN pp_values;
            FETCH pp_values INTO pp_reg;
            WHILE pp_values%FOUND
                LOOP
                    -- Colocar nuevos valores
                    x:=DBMS_RANDOM.VALUE(0,1.3);
                    f_2:=DBMS_RANDOM.VALUE(4,8);

                    IF x >= 1 THEN
                        f_1:=DBMS_RANDOM.VALUE(1,2);
                        horas:=ROUND(f_1/x);
                    ELSIF x < 1 AND x >= 0.8 THEN 
                        f_1:=DBMS_RANDOM.VALUE(1,2);
                        horas:=ROUND(f_1/x);
                    ELSIF x < 0.8 AND x >= 0.5 THEN 
                        f_1:=DBMS_RANDOM.VALUE(1,4);
                        horas:=ROUND(f_1/x);
                        horas:=ROUND(horas/2);
                    ELSIF x < 0.5 AND x >= 0.3 THEN 
                        f_1:=DBMS_RANDOM.VALUE(1,8);
                        horas:=ROUND(f_1/x);
                        horas:=ROUND(horas/4);
                    ELSE
                        f_1:=DBMS_RANDOM.VALUE(2,12);
                        horas:=ROUND(f_1/x);
                        horas:=ROUND(horas/8);
                    END IF;

                    new_vs:= ROUND(pp_reg.v_sub/f_1, 2);
                    new_vd:= ROUND(pp_reg.v_des/f_1, 2);

                    SELECT p.pers.nom1, p.pers.ape1
                    INTO nombre, apellido
                    FROM personas p
                    WHERE p.id = pp_reg.id_persona;

                    SELECT nom 
                    INTO proveedor
                    FROM proveedores
                    WHERE id = pp_reg.id_proveedor;
                    
                    DBMS_OUTPUT.PUT_LINE('La persona ' || nombre || ' ' || apellido || ' con internet de ' || proveedor
                    || ' sufrio los siguientes cambios en su servicio: Velocidad de subida ' || pp_reg.v_sub || '->' || new_vs
                    || ' Velocidad de descarga: ' || pp_reg.v_des || '->' || new_vd || ' Horas diarias de interrupcion ' || pp_reg.h_int || '->'|| horas);

                    INSERT INTO P_PROV VALUES (id_p_prov_seq.nextval, pp_reg.id_persona, pp_reg.id_proveedor, new_vs, new_vd, horas, historia(fecha_i, fecha_f));

                FETCH pp_values INTO pp_reg;
                END LOOP;
            CLOSE pp_values;

        ELSIF in_modelo = 1 THEN 
            -- Seleccionar registros de la tabla de uso de internet que se ubiquen en el estado especificado
            OPEN pp_values;
            FETCH pp_values INTO pp_reg;
            WHILE pp_values%FOUND
                LOOP
                    -- Colocar nuevos valores
                    horas:=ROUND(DBMS_RANDOM.VALUE(1,5));
                    new_vs:= ROUND(DBMS_RANDOM.VALUE(0,300), 2);
                    new_vd:= ROUND(DBMS_RANDOM.VALUE(0,500), 2);
                    
                    DBMS_OUTPUT.PUT_LINE('La persona ' || nombre || ' ' || apellido || ' con internet de ' || proveedor
                    || ' sufrio los siguientes cambios en su servicio: Velocidad de subida ' || pp_reg.v_sub || '->' || new_vs
                    || ' Velocidad de descarga: ' || pp_reg.v_des || '->' || new_vd || ' Horas diarias de interrupcion ' || pp_reg.h_int || '->'|| horas);
                    
                    INSERT INTO P_PROV VALUES (id_p_prov_seq.nextval, pp_reg.id_persona, pp_reg.id_proveedor, new_vs, new_vd, horas, historia(fecha_i, fecha_f));

                FETCH pp_values INTO pp_reg;
                END LOOP;
            CLOSE pp_values;
        END IF;
END;
/
CREATE OR REPLACE PROCEDURE HOSPITALES (fecha_i date, fecha_f date)
IS
i number; -- Iterador
cont_externo number; 
-- Valores output
CURSOR insumos_hospital IS
    SELECT i.nom insumo, r.nom recinto, hi.cant
    FROM H_I hi 
    JOIN recintos_salud r ON r.id = hi.id_rec_salud
    JOIN insumos i ON i.id = hi.id_insumo;
BEGIN
    -- Numero de iteraciones
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

    FOR rec IN insumos_hospital LOOP
        DBMS_OUTPUT.PUT_LINE('El hospital ' || rec.recinto || ' posee ' || rec.cant || ' de ' ||
        rec.insumo);
    END LOOP;

    LOOP
        -- Contar cuantas personas se encuentran en tratamiento en el intervalo determinado
        -- Restar insumos diariamente dependiendo de la cantidad de personas que hay
        UPDATE H_I hi SET hi.cant = hi.cant - (
            SELECT COUNT(*) FROM historico_tratamiento h WHERE
            (h.hist.fec_i BETWEEN fecha_i AND fecha_f OR h.hist.fec_f BETWEEN fecha_i AND fecha_f)
        ); 
                
    cont_externo:= cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP; 

    FOR res IN insumos_hospital LOOP
        DBMS_OUTPUT.PUT_LINE('El hospital ' || res.recinto || ' le quedan ' || res.cant || ' de ' ||
        res.insumo || ' luego de la simulacion');
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE AYUDA_HUMANITARIA (fecha_i date, fecha_f date)
IS
i number; -- Iterador
cont_externo number; 
most_travels number;
receiver number;
gives number;
cont_resources number; -- Iterar para dar los recursos
n_resources number; -- Numero de recursos que se van a donar
random_n_resources number; -- Numero de recursos por donacion (random)
random_resource number;
money number;
help_id number;
-- Valores output
pais_da paises.nom%type;
pais_recibe paises.nom%type;
insumo insumos.nom%type;
BEGIN
    -- Numero de iteraciones
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

    LOOP
    -- Si hay menos de 100 insumos de algo en un hospital se recargaran 100
        UPDATE H_I hi SET hi.cant = hi.cant + 100;

    -- Ayuda humanitaria al azar
    -- Elegir pais con mas viajes en el periodo dado (fecha_i + cont), (fecha_f + cont)
        SELECT COUNT(*)
        INTO most_travels
        FROM (SELECT p.id ,COUNT(*) 
        FROM HISTORICO_VIAJES h
        JOIN estados e on e.id = h.id_estado_2
        JOIN paises p on p.id = e.id_pais
        GROUP BY p.id
        ORDER BY COUNT(*) DESC
        )
        WHERE ROWNUM = 1;

        SELECT id 
        INTO receiver
        FROM (SELECT p.id FROM paises p WHERE p.id <> most_travels 
        ORDER BY DBMS_RANDOM.RANDOM)
        WHERE ROWNUM = 1;

        gives:= DBMS_RANDOM.VALUE(0,1);

        IF gives < 0.40 THEN
            n_resources:= TRUNC(DBMS_RANDOM.VALUE(1,4));
            cont_resources:=0;

            -- Dar dinero
            money:= TRUNC(DBMS_RANDOM.VALUE(1,10))*100000;

            INSERT INTO historico_ayuda_humanitaria VALUES (id_hist_ayuda_seq.nextval, historia(fecha_i + cont_externo, fecha_f + cont_externo), money, most_travels, receiver);
            
            SELECT h.id 
            INTO help_id 
            FROM historico_ayuda_humanitaria h 
            WHERE h.hist.fec_i = fecha_i + cont_externo AND h.hist.fec_f = fecha_f + cont_externo
            AND h.dinero = money AND h.id_pais_1 = most_travels AND h.id_pais_2 = receiver AND ROWNUM = 1;

            SELECT nom INTO pais_da
            FROM paises
            WHERE id = most_travels;

            SELECT nom INTO pais_recibe
            FROM paises
            WHERE id = receiver;

            DBMS_OUTPUT.PUT_LINE(pais_da || ' envia ayuda humanitaria a ' || pais_recibe || ' de ' ||
            money || '$');

            LOOP
                SELECT id 
                INTO random_resource
                FROM (
                    SELECT i.id FROM insumos i 
                    WHERE NOT EXISTS (
                        SELECT * FROM A_I ai WHERE ai.id_insumo = i.id AND ai.id_ayuda = help_id
                    )
                    ORDER BY DBMS_RANDOM.RANDOM
                    )
                WHERE ROWNUM =1;

                SELECT nom 
                INTO insumo 
                FROM insumos 
                WHERE id = random_resource;

                random_n_resources:= TRUNC(DBMS_RANDOM.VALUE(1,5))*1000;

                DBMS_OUTPUT.PUT_LINE(' Se envian ' || random_n_resources || ' de ' ||
                insumo);

                INSERT INTO A_I ai VALUES (random_n_resources, random_resource, help_id);
            
            cont_resources:= cont_resources + 1;
            EXIT WHEN cont_resources = n_resources;
            END LOOP;

        END IF;

    cont_externo:= cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP; 
END;
/
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
/
CREATE OR REPLACE PROCEDURE CONTROL_FRONTERAS (fecha_i date, fecha_f date)
IS
i number; -- Iterador
cont_externo number; 
closable number; --Decidira si la frontera se cierra o no
random_country number;
random_end number;
-- Valores output
pais paises.nom%type;
fecha_cierre date;
fecha_no_cierre date;
BEGIN
-- Numero de iteraciones
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

    LOOP
        closable:=DBMS_RANDOM.VALUE(0,1);

            IF closable < 0.1 THEN
                --Seleccionar pais al azar que no tenga frontera cerrada
                SELECT id 
                INTO random_country
                FROM
                (SELECT p.id
                FROM PAISES p
                WHERE NOT EXISTS (
                    SELECT f.id FROM historico_cierre_fronteras f WHERE (f.id_pais = p.id 
                    AND (((f.hist.fec_i BETWEEN fecha_i AND fecha_f OR
                    f.hist.fec_f BETWEEN fecha_i AND fecha_f)) OR f.hist.fec_f IS NULL
                )))
                ORDER BY DBMS_RANDOM.RANDOM
                )
                WHERE ROWNUM = 1;
                
                random_end:=TRUNC(DBMS_RANDOM.VALUE(30,60));

                -- Output
                SELECT nom 
                INTO pais 
                FROM paises
                WHERE id = random_country;

                fecha_cierre:=fecha_i + cont_externo;
                fecha_no_cierre:= fecha_f + random_end;

                DBMS_OUTPUT.PUT_LINE('El pais ' || pais || ' cierra sus fronteras el ' || fecha_cierre || ' hasta ' ||
                fecha_no_cierre);


                --Registrar cierre de frontera
                INSERT INTO historico_cierre_fronteras VALUES (id_hist_cierre_seq.nextval, historia(fecha_i + cont_externo, fecha_f + random_end), random_country);
            END IF;
        
    cont_externo:= cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP; 
END;