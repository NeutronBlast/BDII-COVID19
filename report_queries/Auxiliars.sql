-- Visitas

CREATE OR REPLACE FUNCTION VISITAS(viaje number) RETURN VARCHAR2 IS
CURSOR visit_values IS 
    SELECT c.nom
    FROM C_HV chv
    JOIN CIUDADES c ON c.id = chv.id_ciudad
    WHERE id_viaje = viaje;

v_name ciudades.nom%type;
v_output VARCHAR2(1500);
BEGIN
    BEGIN
    OPEN visit_values;
    FETCH visit_values INTO v_name;
    WHILE visit_values%FOUND

    LOOP
        IF v_output IS NULL THEN
            v_output := v_name;
        ELSE 
            v_output:= v_output || ' - ' || v_name;
        END IF;
        FETCH visit_values INTO v_name;
    END LOOP;

    CLOSE visit_values;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.put_line('No se encontro ningun dato'||SQLERRM);
    END;

    RETURN (v_output);
END;
/
-- Poblacion

CREATE OR REPLACE FUNCTION POBLACION_PAIS (in_pais NUMBER) RETURN NUMBER IS
resultado number;
BEGIN
    BEGIN 
        SELECT 
        SUM(e.data.poblacion)
        INTO resultado
        FROM ESTADOS e
        WHERE e.id_pais = in_pais;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line('No se encontro ningun dato'||SQLERRM);
    END;

    RETURN (resultado);
END;

/* Concatenador de patologias*/
CREATE OR REPLACE FUNCTION concat_patologia (p_id_pers NUMBER) RETURN VARCHAR2
AS
    CURSOR v_cursor IS 
        SELECT id_patologia
        FROM P_PAT
        WHERE id_persona = p_id_pers;
    v_pat patologias.nom%type;
    v_num_id P_PAT.id_patologia%type;
    v_concat VARCHAR2(2000);
BEGIN
    OPEN v_cursor;
        FETCH v_cursor INTO v_num_id;
        WHILE v_cursor%FOUND 
        LOOP  
            SELECT nom into v_pat FROM patologias WHERE id = v_num_id;
            IF v_concat IS NOT null THEN
                v_concat := v_concat || chr(13) || v_pat;
            ELSE
                v_concat := v_pat;
            END IF;
            FETCH v_cursor INTO v_num_id;
        END LOOP;
    CLOSE v_cursor;

    IF  v_concat IS null THEN
        v_concat := 'N/A';
    END IF;
        
    RETURN (v_concat);
END;

/* Concatenador de Sintomas*/
CREATE OR REPLACE FUNCTION concat_sintoma (p_id_pers NUMBER) RETURN VARCHAR2
AS
    CURSOR v_cursor IS 
        SELECT id_sintoma
        FROM P_S
        WHERE id_persona = p_id_pers;
    v_sint sintomas.nom%type;
    v_num_id P_S.id_sintoma%type;
    v_concat VARCHAR2(2000);
BEGIN
    OPEN v_cursor;
        FETCH v_cursor INTO v_num_id;
        WHILE v_cursor%FOUND 
        LOOP  
            SELECT nom into v_sint FROM sintomas WHERE id = v_num_id;
            IF v_concat IS NOT null THEN
                v_concat := v_concat || chr(13) || v_sint;
            ELSE
                v_concat := v_sint;
            END IF;
            FETCH v_cursor INTO v_num_id;
        END LOOP;
    CLOSE v_cursor;

    IF  v_concat IS null THEN
        v_concat := 'N/A';
    END IF;

    RETURN (v_concat);
END;

/* Concatenador de Fechas de Sintomas*/
CREATE OR REPLACE FUNCTION concat_fec_sintoma (p_id_pers NUMBER) RETURN VARCHAR2
AS
    CURSOR v_cursor IS 
        SELECT fec_i
        FROM P_S
        WHERE id_persona = p_id_pers;

    v_fec P_S.fec_i%type;
    v_str varchar(20);
    v_concat VARCHAR2(2000);
BEGIN
    OPEN v_cursor;
        FETCH v_cursor INTO v_fec;
        WHILE v_cursor%FOUND 
        LOOP  
            IF v_fec IS NOT NULL THEN 
                v_str := TO_CHAR(v_fec, 'DD/MM/YYYY');
            ELSE
                v_str := 'Sin Registro';
            END IF;

            IF v_concat IS NOT null THEN
                v_concat := v_concat || chr(13) || v_str;
            ELSE
                v_concat := v_str;
            END IF;
            FETCH v_cursor INTO v_fec;
        END LOOP;
    CLOSE v_cursor;

    IF  v_concat IS null THEN
        v_concat := 'N/A';
    END IF;
    
    RETURN (v_concat);
END;

/* ¿Tratado con atencion medica? */
CREATE OR REPLACE FUNCTION tratado_si_no (p_id_pers NUMBER) RETURN VARCHAR2
AS
    v_val NUMBER;
    v_si_no VARCHAR2(5);
BEGIN
    SELECT count(*) INTO v_val FROM historico_tratamiento WHERE id_persona = p_id_pers;
    IF v_val > 0 THEN
        v_si_no := 'Si';
    ELSE
        v_si_no := 'No';
    END IF;
    
    RETURN (v_si_no);
END;
