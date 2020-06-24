CREATE OR REPLACE PROCEDURE reporte_1 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, p_pais NUMBER, p_estado VARCHAR, p_edad NUMBER, p_patologia VARCHAR)
AS
BEGIN
    OPEN ORACLE_REF_CURSOR FOR 
        SELECT 
        p.pers.img AS "Foto",
        p.pers.nom1 AS "Primer Nombre",
        p.pers.nom2 AS "Segundo Nombre", 
        p.pers.ape1 AS "Primer Apellido", 
        p.pers.ape2 AS "Segundo Apellido",
        TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
        pa.bandera AS "Pais",
        p.pers.genero AS "Genero",
        e.nom AS "Estado",
        concat_patologia (p.id) AS "Patologia que sufre"
        FROM paises pa
        JOIN estados e ON pa.id = e.id_pais
        JOIN ciudades ci ON e.id = ci.id_estado
        JOIN urbanizaciones u ON ci.id = u.id_ciudad
        JOIN calles ca ON u.id = ca.id_urb
        JOIN personas p ON ca.id = p.id_calle    
        WHERE pa.id = p_pais AND e.id = p_estado AND p.pers.edad(p.pers.fec_nac) = p_edad
        AND EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p_patologia = pt.nom AND p.id=pp.id_persona);
END;

CREATE OR REPLACE PROCEDURE reporte_2 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, p_pais VARCHAR, p_estado VARCHAR )
AS
BEGIN
    OPEN ORACLE_REF_CURSOR FOR 
        SELECT 
        p.id AS "nº ID",
        p.pers.img AS "Foto",
        p.pers.nom1 AS "Primer Nombre",
        p.pers.nom2 AS "Segundo Nombre", 
        p.pers.ape1 AS "Primer Apellido", 
        p.pers.ape2 AS "Segundo Apellido",
        p.pers.edad(p.pers.fec_nac)AS "Edad",
        pa.bandera AS "Pais",
        p.pers.genero AS "Genero",
        e.nom AS "Estado",
        concat_patologia (p.id) AS "Patologia que sufre",
        concat_sintoma (p.id) AS "Sintoma que presenta",
        concat_fec_sintoma (p.id) AS "Fecha de sintoma",
        tratado_si_no (p.id) AS "¿Tratado con atencion medica?"
        FROM paises pa
        JOIN estados e ON pa.id = e.id_pais
        JOIN ciudades ci ON e.id = ci.id_estado
        JOIN urbanizaciones u ON ci.id = u.id_ciudad
        JOIN calles ca ON u.id = ca.id_urb
        JOIN personas p ON ca.id = p.id_calle    
        WHERE pa.id = p_pais AND e.id = p_estado;
END;
