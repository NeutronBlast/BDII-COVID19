CREATE OR REPLACE PROCEDURE HOSPITALES (in_modelo number, fecha_i date, fecha_f date)
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
        -- Contar cuantas personas se encuentran en tratamiento en el intervalo determinado
        -- Restar insumos diariamente dependiendo de la cantidad de personas que hay
        UPDATE H_I hi SET hi.cantidad - (
            SELECT COUNT(*) FROM historico_tratamiento h WHERE
            (hist.fec_i BETWEEN fecha_i AND fecha_f OR hist.fec_f BETWEEN fecha_i AND fecha_f)
        ); 
        
    cont_externo:= cont_externo+1;
    EXIT WHEN cont_externo = i;
    END LOOP; 
END;