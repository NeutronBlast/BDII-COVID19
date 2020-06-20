--numeros infectados
CREATE OR REPLACE TYPE BODY covid_data AS MEMBER FUNCTION numero_infectados(id_estado number) RETURN number
IS resultado number;
BEGIN
    SELECT COUNT(*) INTO resultado FROM INFECTADOS_COVID A WHERE A.id_estado=id_estado AND A.estado = 'I';
    return resultado; 
END;
--numero fallecidos
MEMBER FUNCTION numero_fallecidos(id_estado number) RETURN number
IS resultado number;
BEGIN
    SELECT COUNT(*) INTO resultado FROM INFECTADOS_COVID A WHERE A.id_estado=id_estado AND A.estado = 'M';
    return resultado; 
END;
--numero recuperados
MEMBER FUNCTION numero_recuperados(id_estado number) RETURN number
IS resultado number;
BEGIN
    SELECT COUNT(*) INTO resultado FROM INFECTADOS_COVID A WHERE A.id_estado=id_estado AND A.estado = 'R';
    return resultado; 
END;

--porcentaje_infectados
MEMBER FUNCTION porcentaje_infectados(id_estado number) RETURN number
IS
poblacion number;
total_casos number;
BEGIN
    SELECT A.data.poblacion INTO poblacion FROM ESTADOS A WHERE A.id = id_estado; 
    SELECT COUNT(*) INTO total_casos FROM INFECTADOS_COVID A WHERE A.id_estado=id_estado AND A.estado = 'I';
    return ROUND(total_casos*100/poblacion,2); 
END;
--porcentaje_fallecidos
MEMBER FUNCTION porcentaje_fallecidos(id_estado number) RETURN number
IS resultado number;
poblacion number;
fallecidos number;
total_casos number;
BEGIN
    SELECT COUNT(*) INTO total_casos FROM INFECTADOS_COVID A WHERE A.id_estado=id_estado;
    SELECT COUNT(*) INTO fallecidos FROM INFECTADOS_COVID A WHERE A.id_estado=id_estado AND A.estado = 'M';
    return ROUND(fallecidos*100/total_casos,2); 
END;
--porcentaje_recuperados
MEMBER FUNCTION porcentaje_recuperados(id_estado number) RETURN number
IS resultado number;
poblacion number;
total_casos number;
recuperados number;
BEGIN
    SELECT COUNT(*) INTO total_casos FROM INFECTADOS_COVID A WHERE A.id_estado=id_estado;
    SELECT COUNT(*) INTO recuperados FROM INFECTADOS_COVID A WHERE A.id_estado=id_estado AND A.estado = 'R';
    return ROUND(recuperados*100/total_casos,2); 
END;
END;