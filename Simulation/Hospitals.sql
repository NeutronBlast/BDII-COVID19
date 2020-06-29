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