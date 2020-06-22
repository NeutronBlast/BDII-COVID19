CREATE OR REPLACE PROCEDURE INTERNET (in_modelo number, fecha_i date, fecha_f date)
IS
i number; -- Iterador
cont_externo number; 
BEGIN
    -- Numero de iteraciones
    cont_externo:= 0;
    SELECT TRUNC(fecha_f) - fecha_i
    INTO i
    FROM dual;

    LOOP
    
        
    cont_externo:= cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP; 
END;