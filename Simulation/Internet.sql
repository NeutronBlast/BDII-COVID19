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

    LOOP
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
                    ELSIF x < 0.5 AND x >= 0.3 THEN 
                        f_1:=DBMS_RANDOM.VALUE(1,8);
                        horas:=ROUND(f_1/x);
                    ELSE
                        f_1:=DBMS_RANDOM.VALUE(2,12);
                        horas:=ROUND(f_1/x);
                    END IF;

                    new_vs:= pp_reg.v_sub/f_1;
                    new_vd:= pp_reg.v_des/f_1;

                    INSERT INTO P_PROV VALUES (id_p_prov_seq.nextval, pp_reg.id_persona, pp_reg.id_proveedor, new_vs, new_vd, horas, historia(fecha_i, fecha_f));

                FETCH pp_values INTO pp_reg;
                END LOOP;
            CLOSE pp_values;
            END IF;
        
    cont_externo:= cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP; 
END;