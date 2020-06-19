--numeros infectados
CREATE OR REPLACE TYPE BODY covid_data AS MEMBER FUNCTION numero_infectados(id_pais IN number) RETURN number
IS resultado number;
BEGIN
    SELECT COUNT(*) INTO resultado FROM INFECCIONES_COVID A WHERE A.id_pais=id_pais AND A.estado = "infectado";
    return resultado; 
END;
--numero fallecidos
MEMBER FUNCTION numero_fallecidos(id_pais IN number) RETURN number
IS resultado number;
BEGIN
    SELECT COUNT(*) INTO resultado FROM INFECCIONES_COVID A WHERE A.id_pais=id_pais AND A.estado = "muerto";
    return resultado; 
END;
--numero recuperados
MEMBER FUNCTION numero_recuperados(id_pais IN number) RETURN number
IS resultado number;
BEGIN
    SELECT COUNT(*) INTO resultado FROM INFECCIONES_COVID A WHERE A.id_pais=id_pais AND A.estado = "curado";
    return resultado; 
END;

--porcentaje_infectados
MEMBER FUNCTION porcentaje_infectados(id_pais IN number) RETURN number
IS resultado number;
poblacion number;
BEGIN
    SELECT SUM(A.poblacion) INTO resultado FROM ESTADOS A WHERE A.id_pais = id_pais; 
    SELECT COUNT(*) INTO resultado FROM INFECCIONES_COVID A WHERE A.id_pais=id_pais AND A.estado = "infectado";
    return ROUND(resultado*100/poblacion,2); 
END;
--porcentaje_recuperados
MEMBER FUNCTION porcentaje_recuperados(id_pais IN number) RETURN number
IS resultado number;
poblacion number;
BEGIN
    SELECT COUNT(*) INTO total_casos FROM INFECCIONES_COVID A WHERE A.id_pais=id_pais;
    SELECT COUNT(*) INTO recuperados FROM INFECCIONES_COVID A WHERE A.id_pais=id_pais AND A.estado = "curado";
    return ROUND(recuperados*100/total_casos,2); 
END;
--porcentaje_fallecidos
MEMBER FUNCTION porcentaje_recuperados(id_pais IN number) RETURN number
IS resultado number;
poblacion number;
BEGIN
    SELECT COUNT(*) INTO total_casos FROM INFECCIONES_COVID A WHERE A.id_pais=id_pais;
    SELECT COUNT(*) INTO fallecidos FROM INFECCIONES_COVID A WHERE A.id_pais=id_pais AND A.estado = "muerto";
    return ROUND(fallecidos*100/total_casos,2); 
END;
END;