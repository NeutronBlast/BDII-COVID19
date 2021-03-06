-- Reporte 1
CREATE OR REPLACE PROCEDURE REPORTE_1 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, p_pais NUMBER, p_estado NUMBER, p_edad NUMBER, p_patologia VARCHAR)
AS
BEGIN
    IF p_pais = 0 OR p_estado = 0 OR p_edad = 0 THEN
        IF p_pais = 0 THEN
            IF p_estado = 0 THEN
                IF p_edad = 0 THEN
                    IF p_patologia = 'SI' OR p_patologia = 'Si' OR p_patologia = 'si' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSIF p_patologia = 'NO' OR p_patologia = 'No' OR p_patologia = 'no' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE NOT EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSE
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais;
                    END IF;
                ELSE
                    IF p_patologia = 'SI' OR p_patologia = 'Si' OR p_patologia = 'si' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE p.pers.edad(p.pers.fec_nac) = p_edad
                            AND EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSIF p_patologia = 'NO' OR p_patologia = 'No' OR p_patologia = 'no' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE p.pers.edad(p.pers.fec_nac) = p_edad
                            AND NOT EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSE
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE p.pers.edad(p.pers.fec_nac) = p_edad;
                    END IF;
                END IF;
            ELSE
                IF p_edad = 0 THEN
                    IF p_patologia = 'SI' OR p_patologia = 'Si' OR p_patologia = 'si' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE e.id = p_estado
                            AND EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSIF p_patologia = 'NO' OR p_patologia = 'No' OR p_patologia = 'no' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE e.id = p_estado
                            AND NOT EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSE
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE e.id = p_estado;
                    END IF;
                ELSE

                    IF p_patologia = 'SI' OR p_patologia = 'Si' OR p_patologia = 'si' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE e.id = p_estado AND p.pers.edad(p.pers.fec_nac) = p_edad
                            AND EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSIF p_patologia = 'NO' OR p_patologia = 'No' OR p_patologia = 'no' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE e.id = p_estado AND p.pers.edad(p.pers.fec_nac) = p_edad
                            AND NOT EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSE
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE e.id = p_estado AND p.pers.edad(p.pers.fec_nac) = p_edad;
                    END IF;
                END IF;
            END IF;
        ELSE 
            IF p_estado = 0 THEN
                IF p_edad = 0 THEN
                    IF p_patologia = 'SI' OR p_patologia = 'Si' OR p_patologia = 'si' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE pa.id = p_pais
                            AND EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSIF p_patologia = 'NO' OR p_patologia = 'No' OR p_patologia = 'no' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE pa.id = p_pais
                            AND NOT EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSE
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE pa.id = p_pais;
                    END IF;
                ELSE
                    IF p_patologia = 'SI' OR p_patologia = 'Si' OR p_patologia = 'si' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE pa.id = p_pais AND p.pers.edad(p.pers.fec_nac) = p_edad
                            AND EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSIF p_patologia = 'NO' OR p_patologia = 'No' OR p_patologia = 'no' THEN
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE pa.id = p_pais AND p.pers.edad(p.pers.fec_nac) = p_edad
                            AND NOT EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                    ELSE
                        OPEN ORACLE_REF_CURSOR FOR 
                            SELECT 
                            p.pers.img AS "Foto",
                            p.pers.nom1 AS "Primer Nombre",
                            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                            p.pers.ape1 AS "Primer Apellido", 
                            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                            TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                            pa.bandera AS "Pais",
                            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                            e.nom AS "Estado",
                            concat_patologia (p.id) AS "Patologia que sufre"
                            FROM personas p
                            JOIN (
                                SELECT ic.id_persona, min(ic.estado) as "proxy" 
                                FROM infectados_covid ic
                                WHERE ic.estado = 'I'
                                GROUP BY ic.id_persona
                                ) t ON t.id_persona = p.id
                            JOIN calles ca ON ca.id = p.id_calle
                            JOIN urbanizaciones u ON u.id = ca.id_urb
                            JOIN ciudades ci ON ci.id = u.id_ciudad
                            JOIN estados e ON e.id = ci.id_estado
                            JOIN paises pa ON pa.id = e.id_pais
                            WHERE pa.id = p_pais AND p.pers.edad(p.pers.fec_nac) = p_edad;
                    END IF;
                END IF;
            ELSE
                IF p_patologia = 'SI' OR p_patologia = 'Si' OR p_patologia = 'si' THEN
                    OPEN ORACLE_REF_CURSOR FOR 
                        SELECT 
                        p.pers.img AS "Foto",
                        p.pers.nom1 AS "Primer Nombre",
                        NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                        p.pers.ape1 AS "Primer Apellido", 
                        NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                        TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                        pa.bandera AS "Pais",
                        (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                        e.nom AS "Estado",
                        concat_patologia (p.id) AS "Patologia que sufre"
                        FROM personas p
                        JOIN (
                            SELECT ic.id_persona, min(ic.estado) as "proxy" 
                            FROM infectados_covid ic
                            WHERE ic.estado = 'I'
                            GROUP BY ic.id_persona
                            ) t ON t.id_persona = p.id
                        JOIN calles ca ON ca.id = p.id_calle
                        JOIN urbanizaciones u ON u.id = ca.id_urb
                        JOIN ciudades ci ON ci.id = u.id_ciudad
                        JOIN estados e ON e.id = ci.id_estado
                        JOIN paises pa ON pa.id = e.id_pais
                        WHERE pa.id = p_pais AND e.id = p_estado
                        AND EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                ELSIF p_patologia = 'NO' OR p_patologia = 'No' OR p_patologia = 'no' THEN
                    OPEN ORACLE_REF_CURSOR FOR 
                        SELECT 
                        p.pers.img AS "Foto",
                        p.pers.nom1 AS "Primer Nombre",
                        NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                        p.pers.ape1 AS "Primer Apellido", 
                        NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                        TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                        pa.bandera AS "Pais",
                        (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                        e.nom AS "Estado",
                        concat_patologia (p.id) AS "Patologia que sufre"
                        FROM personas p
                        JOIN (
                            SELECT ic.id_persona, min(ic.estado) as "proxy" 
                            FROM infectados_covid ic
                            WHERE ic.estado = 'I'
                            GROUP BY ic.id_persona
                            ) t ON t.id_persona = p.id
                        JOIN calles ca ON ca.id = p.id_calle
                        JOIN urbanizaciones u ON u.id = ca.id_urb
                        JOIN ciudades ci ON ci.id = u.id_ciudad
                        JOIN estados e ON e.id = ci.id_estado
                        JOIN paises pa ON pa.id = e.id_pais
                        WHERE pa.id = p_pais AND e.id = p_estado
                        AND NOT EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
                ELSE
                    OPEN ORACLE_REF_CURSOR FOR 
                        SELECT 
                        p.pers.img AS "Foto",
                        p.pers.nom1 AS "Primer Nombre",
                        NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                        p.pers.ape1 AS "Primer Apellido", 
                        NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                        TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                        pa.bandera AS "Pais",
                        (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                        e.nom AS "Estado",
                        concat_patologia (p.id) AS "Patologia que sufre"
                        FROM personas p
                        JOIN (
                            SELECT ic.id_persona, min(ic.estado) as "proxy" 
                            FROM infectados_covid ic
                            WHERE ic.estado = 'I'
                            GROUP BY ic.id_persona
                            ) t ON t.id_persona = p.id
                        JOIN calles ca ON ca.id = p.id_calle
                        JOIN urbanizaciones u ON u.id = ca.id_urb
                        JOIN ciudades ci ON ci.id = u.id_ciudad
                        JOIN estados e ON e.id = ci.id_estado
                        JOIN paises pa ON pa.id = e.id_pais
                        WHERE pa.id = p_pais AND e.id = p_estado;
                END IF;
            END IF;
        END IF;
    ELSE
    -- Presenta patologia
        IF p_patologia = 'SI' OR p_patologia = 'Si' OR p_patologia = 'si' THEN
            OPEN ORACLE_REF_CURSOR FOR 
                SELECT 
                p.pers.img AS "Foto",
                p.pers.nom1 AS "Primer Nombre",
                NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                p.pers.ape1 AS "Primer Apellido", 
                NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                pa.bandera AS "Pais",
                (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                e.nom AS "Estado",
                concat_patologia (p.id) AS "Patologia que sufre"
                FROM personas p
                JOIN (
                    SELECT ic.id_persona, min(ic.estado) as "proxy" 
                    FROM infectados_covid ic
                    WHERE ic.estado = 'I'
                    GROUP BY ic.id_persona
                    ) t ON t.id_persona = p.id
                JOIN calles ca ON ca.id = p.id_calle
                JOIN urbanizaciones u ON u.id = ca.id_urb
                JOIN ciudades ci ON ci.id = u.id_ciudad
                JOIN estados e ON e.id = ci.id_estado
                JOIN paises pa ON pa.id = e.id_pais
                WHERE pa.id = p_pais AND e.id = p_estado AND p.pers.edad(p.pers.fec_nac) = p_edad
                AND EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
        ELSIF p_patologia = 'NO' OR p_patologia = 'No' OR p_patologia = 'no' THEN
            OPEN ORACLE_REF_CURSOR FOR 
                SELECT 
                p.pers.img AS "Foto",
                p.pers.nom1 AS "Primer Nombre",
                NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                p.pers.ape1 AS "Primer Apellido", 
                NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                pa.bandera AS "Pais",
                (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                e.nom AS "Estado",
                concat_patologia (p.id) AS "Patologia que sufre"
                FROM personas p
                JOIN (
                    SELECT ic.id_persona, min(ic.estado) as "proxy" 
                    FROM infectados_covid ic
                    WHERE ic.estado = 'I'
                    GROUP BY ic.id_persona
                    ) t ON t.id_persona = p.id
                JOIN calles ca ON ca.id = p.id_calle
                JOIN urbanizaciones u ON u.id = ca.id_urb
                JOIN ciudades ci ON ci.id = u.id_ciudad
                JOIN estados e ON e.id = ci.id_estado
                JOIN paises pa ON pa.id = e.id_pais
                WHERE pa.id = p_pais AND e.id = p_estado AND p.pers.edad(p.pers.fec_nac) = p_edad
                AND NOT EXISTS (SELECT * FROM patologias pt JOIN P_PAT pp ON pt.id = pp.id_patologia WHERE p.id=pp.id_persona);
        ELSE
            OPEN ORACLE_REF_CURSOR FOR 
                SELECT 
                p.pers.img AS "Foto",
                p.pers.nom1 AS "Primer Nombre",
                NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                p.pers.ape1 AS "Primer Apellido", 
                NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                TO_CHAR(p.pers.fec_nac, 'DD/MM/YYYY') AS "Fecha de Nacimiento",
                pa.bandera AS "Pais",
                (CASE WHEN p.pers.genero = 'M' THEN 'Masculino' ELSE 'Femenino' END) AS "Genero",
                e.nom AS "Estado",
                concat_patologia (p.id) AS "Patologia que sufre"
                FROM personas p
                JOIN (
                    SELECT ic.id_persona, min(ic.estado) as "proxy" 
                    FROM infectados_covid ic
                    WHERE ic.estado = 'I'
                    GROUP BY ic.id_persona
                    ) t ON t.id_persona = p.id
                JOIN calles ca ON ca.id = p.id_calle
                JOIN urbanizaciones u ON u.id = ca.id_urb
                JOIN ciudades ci ON ci.id = u.id_ciudad
                JOIN estados e ON e.id = ci.id_estado
                JOIN paises pa ON pa.id = e.id_pais
                WHERE pa.id = p_pais AND e.id = p_estado AND p.pers.edad(p.pers.fec_nac) = p_edad;
        END IF;
    END IF;
END;
/
-- Reporte 2
CREATE OR REPLACE PROCEDURE REPORTE_2 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, p_pais NUMBER, p_estado NUMBER, p_edad NUMBER)
AS
BEGIN
    IF p_pais = 0 OR p_estado = 0 OR p_edad = 0 THEN
        IF p_pais = 0 THEN
            IF p_estado = 0 THEN
                IF p_edad = 0 THEN
                    OPEN ORACLE_REF_CURSOR FOR 
                        SELECT 
                        p.id AS "Nº ID",
                        p.pers.img AS "Foto",
                        p.pers.nom1 AS "Primer Nombre",
                        NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                        p.pers.ape1 AS "Primer Apellido", 
                        NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                        p.pers.edad(p.pers.fec_nac)AS "Edad",
                        pa.bandera AS "Pais",
                        (CASE WHEN p.pers.genero = 'M' THEN 'Masculino'
                        ELSE 'Femenino' END) AS "Genero",
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
                        WHERE EXISTS ( SELECT * FROM P_S WHERE id_persona = p.id );
                ELSE                    
                    OPEN ORACLE_REF_CURSOR FOR 
                        SELECT 
                        p.id AS "Nº ID",
                        p.pers.img AS "Foto",
                        p.pers.nom1 AS "Primer Nombre",
                        NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                        p.pers.ape1 AS "Primer Apellido", 
                        NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                        p.pers.edad(p.pers.fec_nac)AS "Edad",
                        pa.bandera AS "Pais",
                       (CASE WHEN p.pers.genero = 'M' THEN 'Masculino'
                        ELSE 'Femenino' END) AS "Genero",
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
                        WHERE p.pers.edad(p.pers.fec_nac) = p_edad
                        AND EXISTS ( SELECT * FROM P_S WHERE id_persona = p.id );
                END IF;
            ELSE
                IF p_edad = 0 THEN
                    OPEN ORACLE_REF_CURSOR FOR 
                        SELECT 
                        p.id AS "Nº ID",
                        p.pers.img AS "Foto",
                        p.pers.nom1 AS "Primer Nombre",
                        NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                        p.pers.ape1 AS "Primer Apellido", 
                        NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                        p.pers.edad(p.pers.fec_nac)AS "Edad",
                        pa.bandera AS "Pais",
                        (CASE WHEN p.pers.genero = 'M' THEN 'Masculino'
                        ELSE 'Femenino' END) AS "Genero",
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
                        WHERE e.id = p_estado
                        AND EXISTS ( SELECT * FROM P_S WHERE id_persona = p.id );
                ELSE
                    OPEN ORACLE_REF_CURSOR FOR 
                        SELECT 
                        p.id AS "Nº ID",
                        p.pers.img AS "Foto",
                        p.pers.nom1 AS "Primer Nombre",
                        NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                        p.pers.ape1 AS "Primer Apellido", 
                        NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                        p.pers.edad(p.pers.fec_nac)AS "Edad",
                        pa.bandera AS "Pais",
                        (CASE WHEN p.pers.genero = 'M' THEN 'Masculino'
                        ELSE 'Femenino' END) AS "Genero",
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
                        WHERE e.id = p_estado AND p.pers.edad(p.pers.fec_nac) = p_edad
                        AND EXISTS ( SELECT * FROM P_S WHERE id_persona = p.id );
                END IF;
            END IF;
        ELSE
            IF p_estado = 0 THEN
                IF p_edad = 0 THEN 
                    OPEN ORACLE_REF_CURSOR FOR 
                        SELECT 
                        p.id AS "Nº ID",
                        p.pers.img AS "Foto",
                        p.pers.nom1 AS "Primer Nombre",
                        NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                        p.pers.ape1 AS "Primer Apellido", 
                        NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                        p.pers.edad(p.pers.fec_nac)AS "Edad",
                        pa.bandera AS "Pais",
                        (CASE WHEN p.pers.genero = 'M' THEN 'Masculino'
                        ELSE 'Femenino' END) AS "Genero",
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
                        WHERE pa.id = p_pais
                        AND EXISTS ( SELECT * FROM P_S WHERE id_persona = p.id );
                ELSE
                    OPEN ORACLE_REF_CURSOR FOR 
                        SELECT 
                        p.id AS "Nº ID",
                        p.pers.img AS "Foto",
                        p.pers.nom1 AS "Primer Nombre",
                        NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                        p.pers.ape1 AS "Primer Apellido", 
                        NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                        p.pers.edad(p.pers.fec_nac)AS "Edad",
                        pa.bandera AS "Pais",
                        (CASE WHEN p.pers.genero = 'M' THEN 'Masculino'
                        ELSE 'Femenino' END) AS "Genero",
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
                        WHERE pa.id = p_pais AND p.pers.edad(p.pers.fec_nac) = p_edad
                        AND EXISTS ( SELECT * FROM P_S WHERE id_persona = p.id );
                END IF;
            ELSE
                OPEN ORACLE_REF_CURSOR FOR 
                    SELECT 
                    p.id AS "Nº ID",
                    p.pers.img AS "Foto",
                    p.pers.nom1 AS "Primer Nombre",
                    NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
                    p.pers.ape1 AS "Primer Apellido", 
                    NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
                    p.pers.edad(p.pers.fec_nac)AS "Edad",
                    pa.bandera AS "Pais",
                    (CASE WHEN p.pers.genero = 'M' THEN 'Masculino'
                    ELSE 'Femenino' END) AS "Genero",
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
                    WHERE pa.id = p_pais AND e.id = p_estado
                    AND EXISTS ( SELECT * FROM P_S WHERE id_persona = p.id );
            END IF;
        END IF;
    ELSE
        OPEN ORACLE_REF_CURSOR FOR 
            SELECT 
            p.id AS "Nº ID",
            p.pers.img AS "Foto",
            p.pers.nom1 AS "Primer Nombre",
            NVL(p.pers.nom2, ' ')  AS "Segundo Nombre", 
            p.pers.ape1 AS "Primer Apellido", 
            NVL(p.pers.ape2, ' ') AS "Segundo Apellido",
            p.pers.edad(p.pers.fec_nac)AS "Edad",
            pa.bandera AS "Pais",
            (CASE WHEN p.pers.genero = 'M' THEN 'Masculino'
            ELSE 'Femenino' END) AS "Genero",
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
            WHERE pa.id = p_pais AND e.id = p_estado AND p.pers.edad(p.pers.fec_nac) = p_edad
            AND EXISTS ( SELECT * FROM P_S WHERE id_persona = p.id );
    END IF;
END;
/
-- Reporte 3
CREATE OR REPLACE PROCEDURE REPORTE_3 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, FECHA_INICIO IN DATE, FECHA_FIN IN DATE) IS 
BEGIN
    OPEN ORACLE_REF_CURSOR FOR 
        SELECT p.id AS "Nª Id", p.pers.img AS "Foto", p.pers.nom1 as "Primer Nombre", NVL(p.pers.nom2, ' ') AS "Segundo Nombre",
        p.pers.ape1 as "Primer Apellido", p.pers.ape2 as "Segundo Apellido", p.pers.edad(p.pers.fec_nac)
        AS "Edad", pa.bandera as "Pais de residencia", pv.bandera as "Pais donde viajo", TO_CHAR(h.hist.fec_i, 'DD/MM/YYYY') AS "Fecha de inicio del viaje",
        TO_CHAR(h.hist.fec_f, 'DD/MM/YYYY') AS "Fecha de fin de viaje", visitas(h.id) AS "Lugares donde visito"
        FROM PERSONAS p
        JOIN CALLES c ON c.id = p.id_calle
        JOIN URBANIZACIONES u ON u.id = c.id_urb
        JOIN CIUDADES ci ON ci.id = u.id_ciudad
        JOIN ESTADOS e ON e.id = ci.id_estado
        JOIN PAISES pa ON pa.id = e.id_pais
        -- Join viaje
        JOIN P_HV phv ON phv.id_persona = p.id
        JOIN historico_viajes h ON h.id = phv.id_viaje
        JOIN ESTADOS ev ON ev.id = h.id_estado_2
        JOIN PAISES pv ON pv.id = ev.id_pais
        WHERE h.hist.fec_i BETWEEN TO_DATE(TO_CHAR(FECHA_INICIO, 'DD-MM-YYYY'), 'DD-MM-YYYY') AND TO_DATE(TO_CHAR(FECHA_FIN, 'DD-MM-YYYY'), 'DD-MM-YYYY')
        OR h.hist.fec_f BETWEEN TO_DATE(TO_CHAR(FECHA_INICIO, 'DD-MM-YYYY'), 'DD-MM-YYYY') AND TO_DATE(TO_CHAR(FECHA_FIN, 'DD-MM-YYYY'), 'DD-MM-YYYY')
        ORDER BY h.hist.fec_i;
END;
/
-- Reporte 4
CREATE OR REPLACE PROCEDURE REPORTE_4 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, PAIS IN NUMBER, ESTADO IN NUMBER) IS 
BEGIN
    IF PAIS = 0 OR ESTADO = 0 THEN 
        IF PAIS = 0 AND ESTADO <> 0 THEN
            OPEN ORACLE_REF_CURSOR FOR
            SELECT p.bandera as "Pais", TO_CHAR(POBLACION_PAIS(p.id)) || ' habitantes' as "Poblacion Pais", e.nom || ' - ' || p.nom as "Estado", e.data.numero_infectados(e.id, 'E') as "Infectados",
            TO_CHAR(ROUND(e.data.numero_infectados(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Infectados",
            e.data.numero_fallecidos(e.id, 'E') as "Fallecidos", TO_CHAR(ROUND(e.data.numero_fallecidos(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Fallecidos", e.data.numero_recuperados(e.id, 'E') as "Recuperados",
            TO_CHAR(ROUND(e.data.numero_recuperados(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Recuperados"
            FROM ESTADOS e 
            JOIN PAISES p ON p.id = e.id_pais
            WHERE e.id = ESTADO;
        END IF;

        IF PAIS <> 0 AND ESTADO = 0 THEN 
            OPEN ORACLE_REF_CURSOR FOR
            SELECT p.bandera as "Pais", TO_CHAR(POBLACION_PAIS(PAIS)) || ' habitantes' as "Poblacion Pais", e.nom || ' - ' || p.nom as "Estado", e.data.numero_infectados(e.id, 'E') as "Infectados",
            TO_CHAR(ROUND(e.data.numero_infectados(e.id, 'E')*100/
            POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Infectados",
            e.data.numero_fallecidos(e.id, 'E') as "Fallecidos", TO_CHAR(ROUND(e.data.numero_fallecidos(e.id, 'E')*100/
            POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Fallecidos", e.data.numero_recuperados(e.id, 'E') as "Recuperados",
            TO_CHAR(ROUND(e.data.numero_recuperados(e.id, 'E')*100/
            POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Recuperados"
            FROM ESTADOS e 
            JOIN PAISES p ON p.id = e.id_pais
            WHERE e.id_pais = PAIS;
        END IF;

        IF PAIS = 0 AND ESTADO = 0 THEN 
            OPEN ORACLE_REF_CURSOR FOR
            SELECT p.bandera as "Pais", TO_CHAR(POBLACION_PAIS(p.id)) || ' habitantes' as "Poblacion Pais", e.nom || ' - ' || p.nom as "Estado", e.data.numero_infectados(e.id, 'E') as "Infectados",
            TO_CHAR(ROUND(e.data.numero_infectados(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Infectados",
            e.data.numero_fallecidos(e.id, 'E') as "Fallecidos", TO_CHAR(ROUND(e.data.numero_fallecidos(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Fallecidos", e.data.numero_recuperados(e.id, 'E') as "Recuperados",
            TO_CHAR(ROUND(e.data.numero_recuperados(e.id, 'E')*100/
            POBLACION_PAIS(p.id), 4), '0.9999') || '%' as "Porcentaje Recuperados"
            FROM ESTADOS e 
            JOIN PAISES p ON p.id = e.id_pais;
        END IF;

    ELSE 
    OPEN ORACLE_REF_CURSOR FOR
    SELECT p.bandera as "Pais", TO_CHAR(POBLACION_PAIS(PAIS)) || ' habitantes' as "Poblacion Pais", e.nom || ' - ' || p.nom as "Estado", e.data.numero_infectados(e.id, 'E') as "Infectados",
    TO_CHAR(ROUND(e.data.numero_infectados(e.id, 'E')*100/
    POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Infectados",
    e.data.numero_fallecidos(e.id, 'E') as "Fallecidos", TO_CHAR(ROUND(e.data.numero_fallecidos(e.id, 'E')*100/
    POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Fallecidos", e.data.numero_recuperados(e.id, 'E') as "Recuperados",
    TO_CHAR(ROUND(e.data.numero_recuperados(e.id, 'E')*100/
    POBLACION_PAIS(PAIS), 4), '0.9999') || '%' as "Porcentaje Recuperados"
    FROM ESTADOS e 
    JOIN PAISES p ON p.id = e.id_pais
    WHERE e.id_pais = PAIS AND e.id = ESTADO;
    END IF;
END;

/

-- Reporte 5
CREATE OR REPLACE PROCEDURE REPORTE_5 (ORACLE_REF_CURSOR OUT SYS_REFCURSOR, PAIS IN NUMBER) IS 
BEGIN

    IF PAIS <> 0 THEN 
    OPEN ORACLE_REF_CURSOR FOR 
        SELECT p.bandera as "Pais", h.hist.fec_i as "Fecha de Inicio", NVL(h.hist.fec_f, to_date('31/12/2020', 'DD-MM-YYYY')) as "Fecha Fin", 
        'Modelo ' || m.id || ' - ' || m.nom as "Modelo"
        FROM historico_modelos h 
        JOIN estados e ON e.id = h.id_estado
        JOIN paises p ON p.id = e.id_pais
        JOIN modelos m ON m.id = h.id_modelo
        WHERE p.id = PAIS
        ORDER BY h.hist.fec_i;
    ELSE 
        OPEN ORACLE_REF_CURSOR FOR 
        SELECT p.bandera as "Pais", h.hist.fec_i as "Fecha de Inicio", NVL(h.hist.fec_f, to_date('31/12/2020', 'DD-MM-YYYY')) as "Fecha Fin", 
        'Modelo ' || m.id || ' - ' || m.nom as "Modelo"
        FROM historico_modelos h 
        JOIN estados e ON e.id = h.id_estado
        JOIN paises p ON p.id = e.id_pais
        JOIN modelos m ON m.id = h.id_modelo
        ORDER BY p.id;
    END IF;
END;

/

-- Reporte 6
CREATE OR REPLACE PROCEDURE REPORTE_6(ORACLE_REF_CURSOR OUT SYS_REFCURSOR, FECHA_INICIO IN DATE, FECHA_FIN IN DATE,num_pais IN NUMBER) IS
BEGIN
    IF num_pais = 0 THEN
        OPEN ORACLE_REF_CURSOR FOR
        SELECT 'Mundial' as "nom",null as "bandera",(SELECT COUNT(*) FROM infectados_covid a 
                WHERE a.estado = 'I' AND (a.hist.fec_f IS NULL) AND (a.hist.fec_i BETWEEN FECHA_INICIO AND i.hist.fec_i)) as "infectados",
                i.hist.fec_i as "Fecha"
                FROM infectados_covid i 
                WHERE i.estado = 'I' AND (i.hist.fec_f IS NULL) AND (i.hist.fec_i BETWEEN FECHA_INICIO AND FECHA_FIN) ORDER BY i.hist.fec_i asc;
    ELSE
    OPEN ORACLE_REF_CURSOR FOR
        SELECT p.nom,p.bandera,(SELECT COUNT(*) FROM infectados_covid a 
                JOIN ESTADOS e ON a.id_estado = e.id
                JOIN PAISES p ON e.id_pais = p.id
                WHERE p.id = num_pais AND a.estado = 'I' AND (a.hist.fec_f IS NULL) AND (a.hist.fec_i BETWEEN FECHA_INICIO AND i.hist.fec_i)) as "infectados",
                i.hist.fec_i as "Fecha"
                FROM infectados_covid i 
                JOIN ESTADOS e ON i.id_estado = e.id
                JOIN PAISES p ON e.id_pais = p.id
                WHERE p.id = num_pais AND i.estado = 'I' AND (i.hist.fec_f IS NULL) AND (i.hist.fec_i BETWEEN FECHA_INICIO AND FECHA_FIN) ORDER BY i.hist.fec_i asc;
    END IF;
END;