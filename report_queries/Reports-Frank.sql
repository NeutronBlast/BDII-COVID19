-- Reporte 3

-- Query
SELECT p.id AS "Nª Id", p.pers.img AS "Foto", p.pers.nom1 as "Primer Nombre", NVL(p.pers.nom1, '') AS "Segundo Nombre",
p.pers.ape1 as "Primer Apellido", p.pers.ape2 as "Segundo Apellido", p.pers.edad(p.pers.fec_nac)
AS "Edad", pa.bandera as "Pais de residencia", pv.bandera as "Pais donde viajo", h.hist.fec_i AS "Fecha de inicio del viaje",
h.hist.fec_f AS "Fecha de fin de viaje", visitas(h.id) AS "Lugares donde visito"
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
JOIN PAISES pv ON pv.id = ev.id_pais;