CREATE OR REPLACE FUNCTION CONCAT_INSUMO (r_id_rec NUMBER) RETURN VARCHAR2
AS
    CURSOR v_cursor IS 
        SELECT i.nom, hi.cant FROM insumos i
        JOIN H_I hi ON hi.id_insumo = i.id
        WHERE hi.id_rec_salud = r_id_rec;
    v_insumo insumos.nom%type;
    v_cant H_I.cant%type;
    v_concat VARCHAR2(5000);
BEGIN
    OPEN v_cursor;
        FETCH v_cursor INTO v_insumo, v_cant;
        WHILE v_cursor%FOUND 
        LOOP  
            IF v_concat IS NOT null THEN
                v_concat := v_concat || ' - ' || v_cant || ' de ' || v_insumo;
            ELSE
                v_concat := v_cant || ' de ' || v_insumo;
            END IF;
            FETCH v_cursor INTO v_insumo, v_cant;
        END LOOP;
    CLOSE v_cursor;

    IF  v_insumo IS null THEN
        v_concat := 'Ninguno';
    END IF;

    RETURN (v_concat);
END;

CREATE OR REPLACE FUNCTION CONCAT_AYUDA_INSUMO (a_id_ayuda NUMBER) RETURN VARCHAR2
AS
    CURSOR v_cursor IS 
        SELECT i.nom, ai.cant
        FROM historico_ayuda_humanitaria a
        JOIN A_I ai on ai.id_ayuda = a.id
        JOIN insumos i ON i.id = ai.id_insumo
        WHERE a.id = a_id_ayuda;
    v_insumo insumos.nom%type;
    v_cant A_I.cant%type;
    v_concat VARCHAR2(5000);
BEGIN
    OPEN v_cursor;
        FETCH v_cursor INTO v_insumo, v_cant;
        WHILE v_cursor%FOUND 
        LOOP  
            IF v_concat IS NOT null THEN
                v_concat := v_concat || ' - ' || v_cant || ' de ' || v_insumo;
            ELSE
                v_concat := v_cant || ' de ' || v_insumo;
            END IF;
            FETCH v_cursor INTO v_insumo, v_cant;
        END LOOP;
    CLOSE v_cursor;

    IF  v_insumo IS null THEN
        v_concat := 'Ninguno';
    END IF;

    RETURN (v_concat);
END;