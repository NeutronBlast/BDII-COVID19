/* :) */

-------------------------------------- COUNTRIES -----------------------------------------------------
INSERT INTO PAISES VALUES (id_pais_seq.nextval, 'Estados Unidos', EMPTY_BLOB());

-------------------------------------- STATES -----------------------------------------------------

INSERT INTO ESTADOS VALUES (id_estado_seq.nextval, 'Louisiana', (SELECT id FROM PAISES WHERE nom = 'Estados Unidos'), covid_data(1000));

-------------------------------------- CITIES -----------------------------------------------------
INSERT INTO CIUDADES VALUES (id_ciudad_seq.nextval, 'New Orleans', 
(SELECT e.id FROM ESTADOS e 
JOIN paises p ON p.id = e.id_pais
WHERE e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

-------------------------------------- URBANIZACION -----------------------------------------------------
INSERT INTO URBANIZACIONES VALUES (id_urbanizacion_seq.nextval, 'Tulane', 
(SELECT c.id FROM CIUDADES c
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

-------------------------------------- CALLES -----------------------------------------------------
INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'S. Rendon', 70119, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Tulane' AND c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'S. Clark', 72626, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Tulane' AND c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Perdido', 53158, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Tulane' AND c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Baudin', 54510, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Tulane' AND c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'S. Lopez', 72626, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Tulane' AND c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'S. Salcedo', 75026, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Tulane' AND c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'S. Genois', 51015, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Tulane' AND c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'D Hemecourt', 21555, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Tulane' AND c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Gravier', 54106, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Tulane' AND c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'S. Telemachus', 72005, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Tulane' AND c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));
-------------------------------------- PEOPLE -----------------------------------------------------

INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Frank', null, 'Hesse', 'R', '01/08/1999', null, 'M'),1);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Leo', null, 'Barnes', 'H', '10/05/1996', null, 'M'),1);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Carmina', null, 'Zucceada', 'A', '07/05/1998', null, 'F'),2);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Josh', null, 'Hamilton', 'G', '24/11/1988', null, 'M'),3);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Faryd', null, 'Morningstar', 'D', '17/04/1968', null, 'M'),1);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Kim', null, 'Parker', 'W', '17/11/1998', null, 'F'),5);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Ruby', null, 'Mikan', 'F', '14/08/1992', null, 'F'), 7);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Vladimir', null, 'Makarov', 'F', '04/10/1993', null, 'M'), 9);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Dmitri', null, 'Smirnov', 'A', '14/07/1998', null, 'M'), 10);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Alex', null, 'Preobrazhensky', 'V', '17/04/1996', null, 'M'), 10);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Anna', null, 'Preobrazhensky', 'V', '27/09/1996', null, 'F'), 5);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Ivan', null, 'Kuznetsov', 'D', '17/04/1996', null, 'M'), 4);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'John', null, 'Ki', 'D', '16/10/1997', null, 'M'), 2);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Emily', null, 'Rose', 'C', '07/11/1999', null, 'F'), 8);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Gregg', null, 'Spinetti', 'J', '01/11/1997', null, 'M'), 9);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Niels', null, 'Petersen', 'J', '08/11/1987', null, 'M'), 5);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Shia', null, 'Morgan', 'J', '08/11/1997', null, 'F'), 7);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Shelby', null, 'Morgan', 'J', '01/12/1998', null, 'F'), 2);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Alice', null, 'Nightray', 'F', '08/07/1995', null, 'F'), 5);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Piero', null, 'Vilchez', 'A', '05/07/1998', null, 'M'), 6);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Omar', null, 'Hernandez', 'Barrera', '07/07/1978', null, 'M'), 6);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Stefano', null, 'Hernandez', 'Q', '01/05/1978', null, 'M'), 6);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Jaz', null, 'Radke', 'Q', '01/12/1998', null, 'F'), 8);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Henry', null, 'Modrig', 'Rodriguez', '07/11/1989', null, 'M'), 1);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Kylie', null, 'Hann', 'S', '13/09/1991', null, 'F'), 3);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Gavin', null, 'Cringe', 'Preach', '09/11/1988', null, 'M'), 4);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Alberto', 'Arturo', 'Gavin', 'Colmenares', '12/12/1986', null, 'M'), 4);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Dia', null, 'Hansen', null, '12/03/1996', null, 'F'), 8);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Kingsley', null, 'Coman', 'Jr', '08/07/1998', null, 'M'), 9);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Cassie', null, 'Kench', 'A', '01/09/1999', null, 'F'), 10);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Ethan', null, 'Hartmann', 'A', '05/10/1997', '19/06/2020', 'M'), 10);

-------------------------------------- INFECTED -----------------------------------------------------
INSERT INTO INFECTADOS_COVID VALUES (id_infectado_seq.nextval, historia('19-06-2020', null), 'I', 1, null, 1);
INSERT INTO INFECTADOS_COVID VALUES (id_infectado_seq.nextval, historia('19-06-2020', null), 'I', 5, null, 1);
INSERT INTO INFECTADOS_COVID VALUES (id_infectado_seq.nextval, historia('19-06-2020', null), 'I', 10, null, 1);
INSERT INTO INFECTADOS_COVID VALUES (id_infectado_seq.nextval, historia('10-06-2020', null), 'M', 31, null, 1);