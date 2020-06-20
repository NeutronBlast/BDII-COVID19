/* :) */

-------------------------------------- COUNTRIES -----------------------------------------------------
INSERT INTO PAISES VALUES (id_pais_seq.nextval, 'Estados Unidos', EMPTY_BLOB());
INSERT INTO PAISES VALUES (id_pais_seq.nextval, 'Rusia', EMPTY_BLOB());

-------------------------------------- STATES -----------------------------------------------------

INSERT INTO ESTADOS VALUES (id_estado_seq.nextval, 'Louisiana', (SELECT id FROM PAISES WHERE nom = 'Estados Unidos'), covid_data(1000));
INSERT INTO ESTADOS VALUES (id_estado_seq.nextval, 'Kuban', (SELECT id FROM PAISES WHERE nom = 'Rusia'), covid_data(1000));

-------------------------------------- CITIES -----------------------------------------------------

INSERT INTO CIUDADES VALUES (id_ciudad_seq.nextval, 'New Orleans', 
(SELECT e.id FROM ESTADOS e 
JOIN paises p ON p.id = e.id_pais
WHERE e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

INSERT INTO CIUDADES VALUES (id_ciudad_seq.nextval, 'Krasnodar', 
(SELECT e.id FROM ESTADOS e 
JOIN paises p ON p.id = e.id_pais
WHERE e.nom = 'Kuban' AND p.nom = 'Rusia'
));

-------------------------------------- URBANIZACION -----------------------------------------------------

INSERT INTO URBANIZACIONES VALUES (id_urbanizacion_seq.nextval, 'Tulane', 
(SELECT c.id FROM CIUDADES c
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE c.nom = 'New Orleans' AND e.nom = 'Louisiana' AND p.nom = 'Estados Unidos'
));

INSERT INTO URBANIZACIONES VALUES (id_urbanizacion_seq.nextval, 'Karasun', 
(SELECT c.id FROM CIUDADES c
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE c.nom = 'Krasnodar' AND e.nom = 'Kuban' AND p.nom = 'Rusia'
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

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Ulitsa Prostornaya', 66, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Karasun' AND c.nom = 'Krasnodar' AND e.nom = 'Kuban' AND p.nom = 'Rusia'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Montazhnaya St', 74, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Karasun' AND c.nom = 'Krasnodar' AND e.nom = 'Kuban' AND p.nom = 'Rusia'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Avtomyoka', 144, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Karasun' AND c.nom = 'Krasnodar' AND e.nom = 'Kuban' AND p.nom = 'Rusia'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Uralsib Atm', 111, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Karasun' AND c.nom = 'Krasnodar' AND e.nom = 'Kuban' AND p.nom = 'Rusia'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Prostornaya', 91, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Karasun' AND c.nom = 'Krasnodar' AND e.nom = 'Kuban' AND p.nom = 'Rusia'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Gibdd', 5, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Karasun' AND c.nom = 'Krasnodar' AND e.nom = 'Kuban' AND p.nom = 'Rusia'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Sormovkly Proyezd', 56, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Karasun' AND c.nom = 'Krasnodar' AND e.nom = 'Kuban' AND p.nom = 'Rusia'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Prodolnaya Ulitsa', 43, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Karasun' AND c.nom = 'Krasnodar' AND e.nom = 'Kuban' AND p.nom = 'Rusia'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Zarechnyy Proyezd', 26, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Karasun' AND c.nom = 'Krasnodar' AND e.nom = 'Kuban' AND p.nom = 'Rusia'
));

INSERT INTO CALLES VALUES (id_calle_seq.nextval, 'Tonirovka', 8, 
(SELECT u.id FROM URBANIZACIONES u
JOIN ciudades c ON c.id = u.id_ciudad
JOIN estados e ON e.id = c.id_estado 
JOIN paises p ON p.id = e.id_pais
WHERE u.nom = 'Karasun' AND c.nom = 'Krasnodar' AND e.nom = 'Kuban' AND p.nom = 'Rusia'
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


INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Kendrick', null, 'Lamar', 'A', '10/10/1987', null, 'M'), 11);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Amanda', null, 'Grewell', 'V', '11/01/1997', null, 'F'), 14);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Kasia', 'Gabrielle', 'Hernandez', 'A', '01/05/1957', null, 'F'), 19);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Monica', null, 'Lewinski', 'A', '01/05/1987', null, 'F'), 15);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Jack', null, 'Russell', 'A', '01/08/1997', null, 'M'), 12);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Jonathan', null, 'Davis', 'A', '07/08/1998', null, 'M'), 11);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Nikki', null, 'Melendez', 'A', '02/11/1996', null, 'F'), 17);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Sierra', null, 'Tchvaloski', 'A', '08/01/1999', null, 'F'), 18);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Matthew', null, 'Lawrence', 'A', '08/08/1997', null, 'M'), 11);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Tucker', null, 'Carlson', 'A', '08/07/1990', null, 'M'), 17);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Carson', null, 'Jones', 'A', '17/05/1992', null, 'M'), 20);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Maria', null, 'Pandemia', 'A', '08/01/1990', null, 'F'), 14);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Covid', 'Antonio', 'Fernandez', 'A', '08/10/1987', null, 'M'), 12);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Edward', null, 'Rahme', 'A', '07/11/1998', null, 'M'), 13);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Elliott', null, 'Schneider', 'A', '07/11/1999', null, 'M'), 16);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Jamie', null, 'Leigh', 'A', '25/07/1977', null, 'F'), 11);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Josip', null, 'Meyer', 'A', '17/11/1979', null, 'M'), 12);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Daniela', null, 'Frobel', 'A', '21/05/1978', null, 'F'), 16);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Kim', null, 'Hopkins', 'A', '01/11/1998', null, 'F'), 13);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Susana', null, 'Martinez', 'A', '20/11/1995', null, 'F'), 14);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Luciano', null, 'Salvatore', 'A', '17/02/1998', null, 'M'), 18);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Maggie', null, 'Guzman', 'A', '30/10/1986', null, 'M'), 20);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Kiara', null, 'Lavetic', 'A', '18/10/1987', null, 'F'), 15);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Christine', null, 'Janson', 'A', '01/05/1987', null, 'F'), 17);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Layla', null, 'Morgan', 'A', '05/10/1987', null, 'F'), 17);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Sarah', null, 'Lynn', 'A', '01/01/1998', null, 'M'), 11);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Patrick', null, 'Lucumber', 'A', '18/04/1998', null, 'M'), 15);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Nick', null, 'Marsh', 'A', '05/11/1998', null, 'M'), 14);
INSERT INTO PERSONAS VALUES (id_persona_seq.nextval, persona(EMPTY_BLOB(), 'Karen', null, 'Camacho', 'A', '11/08/1991', null, 'F'), 19);

-------------------------------------- INFECTED -----------------------------------------------------
INSERT INTO INFECTADOS_COVID VALUES (id_infectado_seq.nextval, historia('19-06-2020', null), 'I', 1, null, 1);
INSERT INTO INFECTADOS_COVID VALUES (id_infectado_seq.nextval, historia('19-06-2020', null), 'I', 5, null, 1);
INSERT INTO INFECTADOS_COVID VALUES (id_infectado_seq.nextval, historia('19-06-2020', null), 'I', 10, null, 1);
INSERT INTO INFECTADOS_COVID VALUES (id_infectado_seq.nextval, historia('10-06-2020', null), 'M', 31, null, 1);

-------------------------------------- AIRPLANES -----------------------------------------------------
INSERT INTO aerolineas VALUES (id_aerolinea_seq.nextval, 'Aeroflot', EMPTY_BLOB());

-------------------------------------- TRAVELS -----------------------------------------------------
INSERT INTO historico_viajes VALUES (id_hist_viajes_seq.nextval, historia('19-06-2020', '19-07-2020'), 1, 1, 2, 1);
INSERT INTO historico_viajes VALUES (id_hist_viajes_seq.nextval, historia('19-06-2020', '19-07-2020'), 2, 1, 1, 2);
INSERT INTO historico_viajes VALUES (id_hist_viajes_seq.nextval, historia('19-06-2019', '19-07-2019'), 3, 1, 2, 1);

-------------------------------------- P_HV -----------------------------------------------------
INSERT INTO P_HV VALUES (1, 40);
INSERT INTO P_HV VALUES (1, 41);
INSERT INTO P_HV VALUES (1, 42);
INSERT INTO P_HV VALUES (2, 11);
INSERT INTO P_HV VALUES (3, 43);

-------------------------------------- SYMPTOMS -----------------------------------------------------
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Cansancio');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Conjuntivitis');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Diarrea');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Dificultad para despertarse o permanecer despierto');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Dificultad respiratoria');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Dolor de garganta');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Dolor muscular');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Dolor o presíon en el pecho');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Erupciones cutáneas');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Escalofríos');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Fiebre');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Incapacidad para hablar');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Molestias y dolores');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Nauseas o vómitos');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Perdida de color en las manos');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Perdida del sentido del gusto');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Perdida del sentido del olfato');
INSERT INTO sintomas VALUES (id_sintoma_seq.nextval, 'Tos seca');

-------------------------------------- HOSPITALS -----------------------------------------------------
INSERT INTO recintos_salud VALUES (id_recinto_salud_seq.nextval,'Hospital Medical Center','Pub', 1, 1);
INSERT INTO recintos_salud VALUES (id_recinto_salud_seq.nextval,'Health University Hospital','Priv', 1 ,2);
INSERT INTO recintos_salud VALUES (id_recinto_salud_seq.nextval,'Childens and Women Hospital','Pub', 20, 3);
INSERT INTO recintos_salud VALUES (id_recinto_salud_seq.nextval,'Hospital Johns Hopkins','Pub', 5, 4);
INSERT INTO recintos_salud VALUES (id_recinto_salud_seq.nextval,'Jackson Memorial Hospital','Pub', 7, 5);
INSERT INTO recintos_salud VALUES (id_recinto_salud_seq.nextval,'Hospital General New Orleans','Pub', 1500, 6);
INSERT INTO recintos_salud VALUES (id_recinto_salud_seq.nextval,'Pediatric Rheumatology Program','Priv', 210, 7);
INSERT INTO recintos_salud VALUES (id_recinto_salud_seq.nextval,'Robert Wood Johnson Universty Hospital','Pub', 790, 8);
INSERT INTO recintos_salud VALUES (id_recinto_salud_seq.nextval,'Hospital for Special surgery main hospital','Priv', 530, 9);
INSERT INTO recintos_salud VALUES (id_recinto_salud_seq.nextval,'Nicklaus Childens Hospital','Pub', 650, 10);
