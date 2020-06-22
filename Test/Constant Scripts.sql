--Scripts que voy a hacer a cada rato
-- Infectar
SET SERVEROUTPUT ON;
EXECUTE CADENA_INFECCION (1, 9, '19/06/2020', '29/06/2020');

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
EXECUTE DESTINO (9, '19/06/2020', '29/06/2020');

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

----------------------------------------- VUELOS ------------------------------------------------
SET SERVEROUTPUT ON;
EXECUTE VUELOS ('19/06/2020', '29/06/2020');

-- Select flights
SELECT p.nom AS "PAIS ORIGEN", e.nom AS "ESTADO ORIGEN", pd.nom AS "PAIS DESTINO", ed.nom as "ESTADO DESTINO", p.id, p.pers.nom1 || ' ' || p.pers.ape1, h.hist.fec_i, h.hist.fec_f 
FROM P_HV phv
JOIN personas p ON p.id = phv.id_persona
JOIN historico_viajes h ON h.id = phv.id_viaje
JOIN estados e ON e.id = h.id_estado_1
JOIN paises p ON p.id = e.id_pais
JOIN estados ed ON ed.id = h.id_estado_2
JOIN paises pd ON pd.id = ed.id_pais;

-- Delete
TRUNCATE TABLE historico_viajes;
TRUNCATE TABLE P_HV;

----------------------------------------- FRONTERAS ------------------------------------------------
SET SERVEROUTPUT ON;
EXECUTE CONTROL_FRONTERAS ('19/06/2020', '29/06/2020');

-- Select fronteras
SELECT p.nom, f.hist.fec_i, f.hist.fec_f
FROM HISTORICO_CIERRE_FRONTERAS f 
JOIN PAISES p ON p.id = f.id_pais
ORDER BY f.hist.fec_i;

-- Delete
TRUNCATE TABLE historico_cierre_fronteras;

----------------------------------------- INSUMOS ------------------------------------------------
SET SERVEROUTPUT ON;
EXECUTE HOSPITALES ('19/06/2020', '29/06/2020');

-- Select hospitales

SELECT i.id AS "ID_INSUMO", i.nom, r.id AS "ID_REC", r.nom, hi.cant 
FROM H_I hi
JOIN recintos_salud r ON r.id = hi.id_rec_salud
JOIN insumos i ON i.id = hi.id_insumo;

----------------------------------------- AYUDA ------------------------------------------------
SET SERVEROUTPUT ON;
EXECUTE AYUDA_HUMANITARIA ('19/06/2020', '29/06/2020');

-- Select ayudas humanitarias
SELECT p.nom AS "PAIS ORIGEN", pe.nom AS "PAIS DESTINO", h.hist.fec_i, h.hist.fec_f, h.dinero,
i.nom as "INSUMO", ai.cant 
FROM historico_ayuda_humanitaria h
JOIN PAISES p ON p.id = h.id_pais_1
JOIN PAISES pe ON pe.id = h.id_pais_2
JOIN A_I ai ON ai.id_ayuda = h.id 
JOIN INSUMOS i ON i.id = ai.id_insumo
ORDER BY h.hist.fec_i;