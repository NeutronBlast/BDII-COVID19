CREATE OR REPLACE PROCEDURE CONTROL_FRONTERAS (fecha_i date, fecha_f date)
IS
i number; -- Iterador
cont_externo number; 
closable number; --Decidira si la frontera se cierra o no
random_country number;
random_end number;
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
                    SELECT f.id FROM historico_cierre_fronteras f WHERE f.id_pais = p.id 
                    AND (f.hist.fec_i BETWEEN fecha_i AND fecha_f OR
                    f.hist.fec_f BETWEEN fecha_i AND fecha_f)
                )
                ORDER BY DBMS_RANDOM.RANDOM
                )
                WHERE ROWNUM = 1;
                
                random_end:=TRUNC(DBMS_RANDOM.VALUE(30,60));

                --Registrar cierre de frontera
                INSERT INTO historico_cierre_fronteras VALUES (id_hist_cierre_seq.nextval, historia((SELECT (SYSDATE + cont_externo) FROM DUAL), (SELECT (SYSDATE + cont_externo + random_end) FROM DUAL)), random_country);
            END IF;
        
    cont_externo:= cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP; 
END;