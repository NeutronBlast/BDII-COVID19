--Scripts que voy a hacer a cada rato
SET SERVEROUTPUT ON;
EXECUTE CADENA_INFECCION (1, 1, '19/06/2020', '29/06/2020');

-- Selects
SELECT * FROM INFECTADOS_COVID; 
SELECT p.pers.nom1 || ' ' || p.pers.ape1, i.HIST.FEC_I FROM INFECTADOS_COVID i
JOIN PERSONAS p ON p.id = i.id_persona;

SELECT pe.id, pe.pers.nom1 || ' ' || pe.pers.ape1, p.fec_i, s.id, s.nom FROM P_S p
JOIN PERSONAS pe ON pe.id = p.id_persona
JOIN sintomas s ON s.id = p.id_sintoma;

-- Delete   
DELETE FROM INFECTADOS_COVID WHERE ID > 4;
TRUNCATE TABLE P_S;