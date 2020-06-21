--Scripts que voy a hacer a cada rato
-- Infectar
SET SERVEROUTPUT ON;
EXECUTE CADENA_INFECCION (1, 1, '19/06/2020', '29/06/2020');

-- Selects Infectar
SELECT * FROM INFECTADOS_COVID; 
SELECT p.id, p.pers.nom1 || ' ' || p.pers.ape1, i.HIST.FEC_I FROM INFECTADOS_COVID i
JOIN PERSONAS p ON p.id = i.id_persona
ORDER BY i.hist.fec_i;

SELECT pe.id, pe.pers.nom1 || ' ' || pe.pers.ape1, p.fec_i, s.id, s.nom FROM P_S p
JOIN PERSONAS pe ON pe.id = p.id_persona
JOIN sintomas s ON s.id = p.id_sintoma
ORDER BY p.fec_i;

-- Delete Infectar
DELETE FROM INFECTADOS_COVID WHERE ID > 4;
TRUNCATE TABLE P_S;


----------------------------------------- DESTINO ------------------------------------------------
SET SERVEROUTPUT ON;
EXECUTE DESTINO (1, '19/06/2020', '29/06/2020');

-- Select hospital
SELECT t.id_persona AS "ID_PERSONA", p.pers.nom1 || ' ' || p.pers.ape1 as "NOMBRE Y APELLIDO", t.hist.fec_i
FROM historico_tratamiento t
JOIN personas p ON p.id = t.id_persona
ORDER BY t.hist.fec_i;

-- Select deaths
SELECT p.id, p.pers.nom1 || ' ' || p.pers.ape1 as "NOMBRE Y APELLIDO", p.pers.fec_mue as "MUERTE" 
FROM personas p
WHERE p.pers.fec_mue IS NOT NULL;

-- Select recoveries
SELECT p.id, p.pers.nom1 || ' ' || p.pers.ape1 as "NOMBRE Y APELLIDO", i.hist.fec_f 
FROM personas p
JOIN INFECTADOS_COVID i ON i.id_persona = p.id
WHERE i.estado = 'R';

-- Delete
TRUNCATE TABLE historico_tratamiento;
UPDATE INFECTADOS_COVID i SET i.estado = 'I', i.hist.fec_f = NULL WHERE estado = 'M' OR estado = 'R';
UPDATE PERSONAS p SET p.pers.fec_mue = null WHERE p.pers.fec_mue IS NOT NULL; 