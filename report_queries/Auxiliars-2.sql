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
/
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
/

-- Selecciona el numero de infectados durante el intervalo del modelo en un estado determinado

CREATE OR REPLACE FUNCTION infectados_modelo (m_hm_inicio DATE, m_hm_fin DATE, m_hm_estado NUMBER) RETURN NUMBER 
IS 
resultado NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO resultado
    FROM infectados_covid i
    JOIN personas p ON p.id = i.id_persona
    JOIN calles c ON c.id = p.id_calle
    JOIN urbanizaciones u ON u.id = c.id_urb
    JOIN ciudades ci ON ci.id = u.id_ciudad
    JOIN estados e ON e.id = ci.id_estado
    WHERE i.hist.fec_i >= m_hm_inicio AND (i.hist.fec_f <= m_hm_fin OR i.hist.fec_f IS NULL) AND i.estado = 'I'
    AND e.id = m_hm_estado;

    RETURN resultado;
END;

/
-- Selecciona el numero de fallecidos durante el intervalo del modelo en un estado determinado

CREATE OR REPLACE FUNCTION fallecidos_modelo (m_hm_inicio DATE, m_hm_fin DATE, m_hm_estado NUMBER) RETURN NUMBER 
IS 
resultado NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO resultado
    FROM infectados_covid i
    JOIN personas p ON p.id = i.id_persona
    JOIN calles c ON c.id = p.id_calle
    JOIN urbanizaciones u ON u.id = c.id_urb
    JOIN ciudades ci ON ci.id = u.id_ciudad
    JOIN estados e ON e.id = ci.id_estado
    WHERE i.hist.fec_i >= m_hm_inicio AND (i.hist.fec_f <= m_hm_fin OR i.hist.fec_f IS NULL) AND i.estado = 'M'
    AND e.id = m_hm_estado;

    RETURN resultado;
END;
/
-- Selecciona el numero de recuperados durante el intervalo del modelo en un estado determinado

CREATE OR REPLACE FUNCTION recuperados_modelo (m_hm_inicio DATE, m_hm_fin DATE, m_hm_estado NUMBER) RETURN NUMBER 
IS 
resultado NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO resultado
    FROM infectados_covid i
    JOIN personas p ON p.id = i.id_persona
    JOIN calles c ON c.id = p.id_calle
    JOIN urbanizaciones u ON u.id = c.id_urb
    JOIN ciudades ci ON ci.id = u.id_ciudad
    JOIN estados e ON e.id = ci.id_estado
    WHERE i.hist.fec_i >= m_hm_inicio AND (i.hist.fec_f <= m_hm_fin OR i.hist.fec_f IS NULL) AND i.estado = 'R'
    AND e.id = m_hm_estado;

    RETURN resultado;
END;
