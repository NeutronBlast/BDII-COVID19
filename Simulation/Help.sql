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