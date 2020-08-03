/* funciones */

Create or replace procedure Infectar (id_persona number, fecha_actual date) is
	infectado number;
	prob number;
	sint number;
	cont number;
	sintaux number;
	type numarray IS VARRAY(100) OF number;
	arraynum numarray:= numarray();
	contaux number;
begin
    arraynum.extend(1);
	arraynum(1):=0;
    arraynum.extend(1);
	arraynum(2):=0;
    arraynum.extend(1);
	arraynum(3):=0;
    arraynum.extend(1);
	arraynum(4):=0;
    arraynum.extend(1);
	arraynum(5):=0;
	begin
		Select PES.id into infectado from Persona_y_estado PES Where PES.fk_estado = 1 and PES.fk_persona = id_persona and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then infectado:=NULL;
	end;
	Update Persona_y_estado pes SET pes.fechas_inicio_fin.fecha_fin = (fecha_actual-1) where pes.id = infectado; 
	Insert into Persona_y_estado (fechas_inicio_fin, fk_persona, fk_estado) values (fechas_inicio_fin(fecha_actual, TO_DATE('1/1/2050', 'mm/dd/yyyy')), id_persona, 2);
	Select trunc(dbms_random.value(1,10)) num into prob From dual;
	dbms_output.put_line('Infectada la persona de id ' || id_persona || '.');
	if prob <= 6 then
		Select trunc(dbms_random.value(1,5)) num into sint From dual;
		contaux:= 1;
		For cont IN 1..sint
		LOOP
			Select trunc(dbms_random.value(1,15)) num into sintaux From dual;
			if arraynum(1) = sintaux or arraynum(2) = sintaux or arraynum(3) = sintaux Then
                contaux:=contaux;
			Else
				dbms_output.put_line('S�ntoma de id ' || sintaux || ' agregado a la persona de id ' || id_persona || '.');
				Insert into persona_y_sintoma(fecha_sintoma, fk_persona, fk_sintoma) values(fecha_actual, id_persona, sintaux);
				arraynum.extend(1);
                arraynum(contaux):= sintaux;
				contaux:= contaux +1;
			end if;
		End loop;
	end if;
end;


Create or replace procedure Agregar_patologias (id_persona number) is
	sint number;
	type numarray IS VARRAY(100) OF number;
	arraynum numarray:= numarray();
	contaux number;
	sintaux number;
begin
    arraynum.extend(1);
	arraynum(1):=0;
    arraynum.extend(1);
	arraynum(2):=0;
    arraynum.extend(1);
	arraynum(3):=0;
    arraynum.extend(1);
	arraynum(4):=0;
	Select trunc(dbms_random.value(1,4)) num into sint From dual;
	contaux:= 1;
	For cont IN 1..sint
	LOOP
		Select trunc(dbms_random.value(1,15)) num into sintaux From dual;
		if arraynum(1) = sintaux or arraynum(2) = sintaux or arraynum(3) = sintaux or arraynum(4) = sintaux Then
			sint:=sint;
		Else
			dbms_output.put_line('Patolog�a de id ' || sintaux || ' agregada a la persona de id ' || id_persona || '.');
			Insert into persona_y_patologia(fk_persona, fk_patologia) values(id_persona, sintaux);
            arraynum.extend(1);
			arraynum(contaux):= sintaux;
			contaux:= contaux +1;
		end if;
	End loop;
end;


Create or replace function Contar_infectados_actuales (id_lugar number) return number is
	infectados number;
begin
	begin
		Select count (pes.id) into infectados from Persona_y_estado pes, persona per 
		where
		pes.fk_estado = 2 and pes.fk_persona = per.id 
		and per.fk_lugar in (Select l.id from lugar l where l.fk_lugar = id_lugar) 
		and per.id not in (Select pesta.fk_persona from persona_y_estado pesta where pesta.fk_estado = 3 )
		and per.id not in (Select pesta.fk_persona from persona_y_estado pesta where pesta.fk_estado = 4 );
		EXCEPTION When NO_DATA_FOUND then infectados:=NULL;
	end;
	return infectados;
end;


Create or replace function Porcentaje_infectados_actuales (id_lugar number) return number is
	infectados number;
	porcentaje number;
	poblacion number;
begin
	infectados:= Contar_infectados_actuales(id_lugar);
	begin
		select lug.poblacion into poblacion from lugar lug where lug.id = id_lugar and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then poblacion:=NULL;
	end;
	porcentaje:=(infectados*100)/poblacion;
	return porcentaje;
end;


Create or replace function Obtener_modelo (id_lugar number, fecha_actual date) return number is
	modelo number;
begin
	begin
		Select lumod.fk_modelo into modelo from lugar_y_modelo lumod 
		where
		lumod.fk_lugar = id_lugar
		and lumod.fechas_inicio_fin.fecha_inicio <= fecha_actual
		and lumod.fechas_inicio_fin.fecha_fin >= fecha_actual
		and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then modelo:=NULL;
	end;
	return modelo;
end;


Create or replace procedure Cambiar_modelo (id_lugar number, fecha_actual date) is
	modelo number;
	porcentaje number;
	contaux number;
begin
	modelo:= obtener_modelo(id_lugar, fecha_actual);
	porcentaje:= porcentaje_infectados_actuales(id_lugar);
	if modelo = 1 then
		if porcentaje >=35 then
			Update lugar_y_modelo lm SET lm.fechas_inicio_fin.fecha_fin = (fecha_actual-1) where lm.fk_lugar = id_lugar and lm.fechas_inicio_fin.fecha_fin >= fecha_actual and lm.fk_modelo = 1;
			Insert into lugar_y_modelo (fechas_inicio_fin, fk_lugar, fk_modelo) values(fechas_inicio_fin(fecha_actual, TO_DATE('1/1/2050', 'mm/dd/yyyy')), id_lugar, 2);
			begin
				Select lumo.id into contaux from lugar_y_modelo lumo 
				where 
				lumo.fechas_inicio_fin.fecha_fin > fecha_actual 
				and lumo.fk_lugar = id_lugar 
				and lumo. fk_modelo = 2 
				and rownum<=1;
				EXCEPTION When NO_DATA_FOUND then contaux:=NULL;
			end;
			dbms_output.put_line('----------------------------------------------------------------------------');
			dbms_output.put_line('Cambio de modelo 1 a 2 en el pa�s de id ' || id_lugar || '.');
			dbms_output.put_line('----------------------------------------------------------------------------');
			Insert into cierre_fronteras (fechas_inicio_fin, fk_lugarModelo) values (fechas_inicio_fin(fecha_actual, TO_DATE('1/1/2050', 'mm/dd/yyyy')), contaux);
			dbms_output.put_line('Cierre de fronteras en el pa�s de id ' || id_lugar || '.');
			dbms_output.put_line('----------------------------------------------------------------------------');
		end if;
	else
		if porcentaje <=20 then
			dbms_output.put_line('----------------------------------------------------------------------------');
			dbms_output.put_line('Cambio de modelo 2 a 1 en el pa�s de id ' || id_lugar || '.');
			dbms_output.put_line('----------------------------------------------------------------------------');
			dbms_output.put_line('Fronteras abiertas en el pa�s de id ' || id_lugar || '.');
			dbms_output.put_line('----------------------------------------------------------------------------');
			Update lugar_y_modelo lmo SET lmo.fechas_inicio_fin.fecha_fin = (fecha_actual-1) where lmo.fk_lugar = id_lugar and lmo.fechas_inicio_fin.fecha_fin >= fecha_actual and lmo.fk_modelo = 2;
			Insert into lugar_y_modelo (fechas_inicio_fin, fk_lugar, fk_modelo) values(fechas_inicio_fin(fecha_actual, TO_DATE('1/1/2050', 'mm/dd/yyyy')), id_lugar, 1);
			Update cierre_fronteras cf SET cf.fechas_inicio_fin.fecha_fin = (fecha_actual-1) 
			where cf.fk_lugarModelo = (Select lum.id from lugar_y_modelo lum where lum.fk_lugar = id_lugar and lum.fk_modelo = 2 and lum.fechas_inicio_fin.fecha_fin = fecha_actual);
		end if;
	end if;
end;


Create or replace procedure Crear_historico_internet (id_lugar number, fecha_actual date) is
	subidaaux number;
	descargaaux number; 
	horasaux number;
	fechaaux date;
	fkprov number;
	val number;
	valaux number;
	modelo number;
begin
	begin
		Select intlug.fk_internet into fkprov from Proveedor_internet_y_lugar intlug where intlug.fk_lugar = id_lugar and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then fkprov:=NULL;
	end;
	begin
		Select prov.velocidad_subida_ofrecida into subidaaux from Proveedor_internet prov where prov.id = fkprov and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then subidaaux:=NULL;
	end;
	begin
		Select prov.velocidad_bajada_ofrecida into descargaaux from Proveedor_internet prov where prov.id = fkprov and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then descargaaux:=NULL;
	end;
	Select trunc(dbms_random.value(0,10)) num into horasaux From dual;
	fechaaux:= fecha_actual;
	Select trunc(dbms_random.value(1,10)) num into val From dual;
	Select trunc(dbms_random.value(0,20)) num into valaux From dual;
	if val < 5 then
		subidaaux:= subidaaux-((subidaaux*valaux)/100);
		descargaaux:= descargaaux-((descargaaux*valaux)/100);
	else
		subidaaux:= subidaaux+((subidaaux*valaux)/100);
		descargaaux:= descargaaux+((descargaaux*valaux)/100);
	end if;
	modelo:= obtener_modelo(id_lugar, fecha_actual);
	if modelo = 2 then
		subidaaux:= subidaaux*0.8;
		descargaaux:= descargaaux*0.8;
	end if;
	Insert into historico_internet (velocidad_prom_subida, velocidad_prom_descarga, horas_interrupcion, fecha, fk_proveedor) 
	values (subidaaux, descargaaux, horasaux, fechaaux, fkprov);
	dbms_output.put_line('Hist�rico de internet creado para el pa�s de id ' || id_lugar || ' y el proveedor de id ' || id_lugar || '.');
end;


Create or replace Function ubicacion_actual_persona (id_persona number, fecha_actual date) return number is
	ciudad_resi number;
	ciudad_vuelo number;
	vuelo_activo number;
	viaje_activo number;
begin
	begin
		Select per.fk_lugar into ciudad_resi from persona per where per.id = id_persona and rownum<=1; 
		EXCEPTION When NO_DATA_FOUND then ciudad_resi:=0;
	end;
	vuelo_activo:=0;
	ciudad_vuelo:=0;
	viaje_activo:=0;
	begin
		Select vi.id into viaje_activo from viaje vi where vi.fk_persona = id_persona and vi.fechas_inicio_fin.fecha_fin >= fecha_actual 
        and vi.fechas_inicio_fin.fecha_inicio <= fecha_actual and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then viaje_activo:=0;
	end;
	if viaje_activo != 0 then
		begin
			Select vuvi.fk_vuelo into vuelo_activo from vuelo_y_viaje vuvi, vuelo vl 
			where vuvi.fk_viaje = viaje_activo and vl.numero_vuelo = vuvi.fk_vuelo and vl.fk_lugar_salida = ciudad_resi and rownum<=1;
			EXCEPTION When NO_DATA_FOUND then vuelo_activo:=0;
		end;
		begin
			Select v.fk_lugar_llegada into ciudad_vuelo from vuelo v where v.numero_vuelo = vuelo_activo and rownum<=1;
			EXCEPTION When NO_DATA_FOUND then ciudad_vuelo:=0;
		end;
	end if;
	if vuelo_activo = 0 then
		return ciudad_resi;
	end if;
	return ciudad_vuelo;
end;


Create or replace Function verificar_vuelo_persona (id_persona number, fecha_actual date) return number is
	ciudad_res number;
begin
	begin
		Select per.fk_lugar into ciudad_res from persona per where per.id = id_persona and rownum<=1; 
		EXCEPTION When NO_DATA_FOUND then ciudad_res:=0;
	end;
	if ciudad_res = ubicacion_actual_persona(id_persona, fecha_actual) then
		return 0;
	end if;
	return 1; 
end;


Create or replace procedure Asignar_pasajeros (vuelo_salida number, vuelo_llegada number, ciudad_salida number, ciudad_llegada number, fecha_actual date) is
	cont number;
	min_ciudad number;
	max_ciudad number;
	fecha_llegada date;
	id_persona number;
	contaux number;
	cantciu number;
	id_viaje number;
	id_lugar number;
	prim_ciudad number;
	ult_ciudad number;
	type numarray IS VARRAY(100) OF number;
	arraynum numarray:= numarray();
	pais_visitado number;
    contcont number;
begin
	fecha_llegada := fecha_actual + 14;
    arraynum.extend(1);
	arraynum(1):=0;
    arraynum.extend(1);
	arraynum(2):=0;
    arraynum.extend(1);
	arraynum(3):=0;
	select min(per.id) into min_ciudad from persona per where per.fk_lugar = ciudad_salida;
	select max(per.id) into max_ciudad from persona per where per.fk_lugar = ciudad_salida;
	begin
		Select ll.fk_lugar into pais_visitado from lugar ll where ll.id = ciudad_llegada and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then pais_visitado:=0;
	end;
	select min(lug.id) into prim_ciudad from lugar lug where lug.fk_lugar = pais_visitado;
	select max(lug.id) into ult_ciudad from lugar lug where lug.fk_lugar = pais_visitado;
	for  cont IN 1..10
	LOOP
		Select trunc(dbms_random.value(min_ciudad,max_ciudad)) num into id_persona From dual;
		if verificar_vuelo_persona (id_persona, fecha_actual) = 0 then
			Insert into viaje (fechas_inicio_fin, fk_persona) values (fechas_inicio_fin(fecha_actual, fecha_llegada), id_persona);
			Select id into id_viaje from (Select id from viaje order by id desc) where rownum<=1;
			Select trunc(dbms_random.value(1,4)) num into cantciu From dual;
            		contcont:=1;
			Insert into ciudad_visitada (fk_viaje, fk_lugar) values (id_viaje, ciudad_llegada);
			for contaux IN 1..cantciu
			LOOP
				Select trunc(dbms_random.value(prim_ciudad,ult_ciudad)) num into id_lugar From dual;
				if arraynum(1) = id_lugar or arraynum(2) = id_lugar or arraynum(3) = id_lugar or id_lugar = ciudad_llegada Then
					contcont:=contcont;
				Else
					Insert into ciudad_visitada (fk_viaje, fk_lugar) values (id_viaje, id_lugar);
                    			arraynum.extend(1);
					arraynum(contcont):= id_lugar;
					contcont:=contcont+1;
				end if;				
			End loop;
			Insert into vuelo_y_viaje (fk_vuelo, fk_viaje) values (vuelo_salida, id_viaje);
			Insert into vuelo_y_viaje (fk_vuelo, fk_viaje) values (vuelo_llegada, id_viaje);
			dbms_output.put_line('Persona de id ' || id_persona || ' asignada a los vuelos de id ' || vuelo_salida || ' y ' || vuelo_llegada || ' en viaje de id ' || id_viaje || '.');
		end if;
	End loop;
end;


Create or replace procedure Generar_vuelos (fecha_actual date) is
	cant_vuelos number;
	ciudad_salida number;
	ciudad_llegada number;
	cont number;
	val number;
	aeroline number;
	pais_salida number;
	pais_llegada number;
	fecha_llegada date;
	vuelo_salida number;
	vuelo_llegada number;
begin
	fecha_llegada := fecha_actual+14;
	Select trunc(dbms_random.value(4,6)) num into cant_vuelos From dual;
	For cont IN 1..cant_vuelos
	LOOP
		val:=0;
		Select trunc(dbms_random.value(16,90)) num into ciudad_salida From dual;
		Select trunc(dbms_random.value(16,90)) num into ciudad_llegada From dual;
		while val = 0
		LOOP
			if ciudad_salida = ciudad_llegada then
				Select trunc(dbms_random.value(16,90)) num into ciudad_llegada From dual;
			else
				val:= 1;
			end if;
		End loop;
		Select trunc(dbms_random.value(1,15)) num into aeroline From dual;
		begin
			Select l.fk_lugar into pais_salida from lugar l where l.id = ciudad_salida and rownum<=1;
			EXCEPTION When NO_DATA_FOUND then ciudad_salida:=0;
		end;
		begin
			Select lu.fk_lugar into pais_llegada from lugar lu where lu.id = ciudad_llegada and rownum<=1;
			EXCEPTION When NO_DATA_FOUND then ciudad_llegada:=0;
		end;
		if obtener_modelo(pais_salida, fecha_actual) = 1 and obtener_modelo(pais_llegada, fecha_actual) = 1 then
			Insert into vuelo (fechas_inicio_fin, fk_lugar_salida, fk_lugar_llegada, fk_aerolinea) values (fechas_inicio_fin(fecha_actual, fecha_actual), ciudad_salida, ciudad_llegada, aeroline);
			Begin
				Select numero_vuelo into vuelo_salida from (Select numero_vuelo from vuelo order by numero_vuelo desc) where rownum<=1;
				EXCEPTION When NO_DATA_FOUND then vuelo_salida:=0;
			end;
			Insert into vuelo (fechas_inicio_fin, fk_lugar_salida, fk_lugar_llegada, fk_aerolinea) values (fechas_inicio_fin(fecha_llegada, fecha_llegada), ciudad_llegada, ciudad_salida, aeroline);
			begin
				Select numero_vuelo into vuelo_llegada from (Select numero_vuelo from vuelo order by numero_vuelo desc) where rownum<=1;
				EXCEPTION When NO_DATA_FOUND then vuelo_llegada:=0;
			end;
			dbms_output.put_line('Generado vuelo con ciudad de salida de id ' || ciudad_salida || ' y ciudad de llegada de id ' || ciudad_llegada || ' con fecha ' || fecha_actual || '.');
			dbms_output.put_line('Generado vuelo con ciudad de salida de id ' || ciudad_llegada || ' y ciudad de llegada de id ' || ciudad_salida || ' con fecha ' || fecha_llegada || '.');
			Asignar_pasajeros(vuelo_salida, vuelo_llegada, ciudad_salida, ciudad_llegada, fecha_actual);
		end if;
	End loop;
end;


Create or replace function Calcular_edad (id_persona number, fecha_actual date) return number is
	edad number;
	fnac date;
begin
	begin
	Select per.fecha_de_nacimiento into fnac from persona per where per.id = id_persona and rownum<=1;
	EXCEPTION When NO_DATA_FOUND then fnac:=NULL;
	end;
	edad:=trunc((fecha_actual - fnac)/365);
	return edad;
end;

CREATE OR REPLACE FUNCTION personaInfectada(id_persona number, fecha_actual date) RETURN number
IS
    auxEstado number;
BEGIN
    BEGIN
        SELECT pe.fk_Estado INTO auxEstado
        FROM Persona_y_Estado pe
        WHERE pe.fk_persona = id_persona AND
        pe.fk_Estado = 2 AND
        fecha_actual between pe.Fechas_inicio_fin.Fecha_Inicio and pe.Fechas_inicio_fin.Fecha_Fin 
        and id_persona not in (Select pesta.fk_persona from persona_y_estado pesta where pesta.fk_estado = 3 )
        and id_persona not in (Select pesta.fk_persona from persona_y_estado pesta where pesta.fk_estado = 4 )
        and rownum<=1;
        EXCEPTION when NO_DATA_FOUND then auxEstado := 0;
    END;

    if (auxEstado != 0) then
        RETURN 1;
    end if;
    RETURN 0;
END;

CREATE OR REPLACE FUNCTION personaHospitalizada(id_persona number, fecha_actual date) RETURN number
IS
    auxInfectado number;
    auxTratado number;
BEGIN
    auxInfectado := personaInfectada(id_persona, fecha_actual);
    BEGIN
        SELECT tratado INTO auxTratado
        FROM persona
        WHERE id = id_persona and rownum<=1;
        EXCEPTION when NO_DATA_FOUND then auxInfectado := null;
    END;

    if (auxTratado = 1 AND auxInfectado = 1) then
        RETURN 1;
    end if;
    RETURN 0;
END;


Create or replace procedure Finalizar_infeccion (id_persona number, fecha_actual date) is
	id_nan number;
begin
	begin
		Select pes.id into id_nan from persona_y_estado pes where pes.fk_persona = id_persona and pes.fk_estado = 2 and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then id_nan:=0;
	end;
	Update Persona_y_estado pest SET pest.fechas_inicio_fin.fecha_fin = (fecha_actual-1) where pest.id = id_nan;
end;


Create or replace procedure Matar_persona (id_persona number, fecha_actual date) is
hospita number;
centro number;
begin
	Finalizar_infeccion (id_persona, fecha_actual);
	dbms_output.put_line('Muerte de la persona con id ' || id_persona || '.');
	Insert into Persona_y_estado (fechas_inicio_fin, fk_persona, fk_estado) values(fechas_inicio_fin(fecha_actual, TO_DATE('1/1/2050', 'mm/dd/yyyy')), id_persona, 4);
    	begin
		Select per.tratado into hospita from persona per where per.id = id_persona and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then hospita:=0;
	end;
	if hospita = 1 then
		begin
			Select per.fk_centroS into centro from Persona per where per.id = id_persona and rownum<=1;
			EXCEPTION When NO_DATA_FOUND then centro:=0;
		end;
		Update centro_de_salud cs set cs.camas_disponibles = cs.camas_disponibles + 1 where cs.id = centro;
	end if;
end;


Create or replace procedure Recuperar_persona (id_persona number, fecha_actual date) is
	centro number;
	hospita number;
begin
	Finalizar_infeccion (id_persona, fecha_actual);
	dbms_output.put_line('La persona con id ' || id_persona || ' se ha recuperado.');
	Insert into Persona_y_estado (fechas_inicio_fin, fk_persona, fk_estado) values(fechas_inicio_fin(fecha_actual, TO_DATE('1/1/2050', 'mm/dd/yyyy')), id_persona, 3);
	begin
		Select per.tratado into hospita from persona per where per.id = id_persona and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then hospita:=0;
	end;
	if hospita = 1 then
		begin
			Select per.fk_centroS into centro from Persona per where per.id = id_persona and rownum<=1;
			EXCEPTION When NO_DATA_FOUND then centro:=0;
		end;
		Update centro_de_salud cs set cs.camas_disponibles = cs.camas_disponibles + 1 where cs.id = centro;
	end if;
end;


Create or replace Function Calcular_probabilidad_muerte (id_persona number, fecha_actual date) return number is
	probfinal number;
	cantsint number;
	cantpato number;
	edad number;
begin 
	probfinal:= 2;
	edad:= calcular_edad(id_persona, fecha_actual);
	Select count(sint.id) into cantsint from persona_y_sintoma sint where sint.fk_persona = id_persona;
	Select count(pato.id) into cantpato from persona_y_patologia pato where pato.fk_persona = id_persona;
	probfinal:= probfinal + (cantsint*2);
	probfinal:= probfinal + (cantpato*5);
	if edad >= 65 then
		probfinal:= probfinal + 40;
	end if;
	if personaHospitalizada(id_persona, fecha_actual) = 1 then
		probfinal:= probfinal - 20;
	end if;
	if probfinal <=0 then
		probfinal:= 0;
	end if;
	return probfinal;
end;

Create or replace Function Calcular_dias_infeccion (id_persona number, fecha_actual date) return number is
	fecha_ini date;
	dias number;
begin
	begin
		Select pes.fechas_inicio_fin.fecha_inicio into fecha_ini from persona_y_estado pes where pes.fk_persona = id_persona and pes.fk_estado = 2 and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then fecha_ini:=NULL;
	end;
	dias:= fecha_actual-fecha_ini;
	return dias;
end;


Create or replace procedure Decidir_muerte_recuperacion (id_persona number, fecha_actual date) is
	prob number;
	res number;
begin
	if personaInfectada(id_persona, fecha_actual) = 1 then
		if calcular_dias_infeccion (id_persona, fecha_actual) = 21 then
			prob:= calcular_probabilidad_muerte(id_persona, fecha_actual);
			Select trunc(dbms_random.value(1,100)) num into res From dual;
			if res <= prob then
				matar_persona (id_persona, fecha_actual);
			else
				recuperar_persona (id_persona, fecha_actual);
			end if;
		end if;
	end if;
end;

Create or replace function calcular_gente_contacto (id_pais number) return number is
	cantidad number;
	poblacion number;
begin
	begin
		Select l.poblacion into poblacion from lugar l where l.id = id_pais and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then poblacion:=0;
	end;
	cantidad:= trunc(poblacion/100) +1;
	return cantidad;
end;

Create or replace function personaSana (id_persona number) return number is
	val number;
begin
	Select count(pes.id) into val from persona_y_estado pes where pes.fk_persona = id_persona;
	if val = 1 then
		return 1;
	end if;
	return 0;
end;


Create or replace Procedure Infeccion (id_persona number, fecha_actual date) is
	ciudad_actual number;
	pais_actual number;
	modelo number;
	prob number;
	val number;
	cant_gente number;
	contaux number;
	min_ciudad number;
	max_ciudad number;
	peraux number;
	vval number;
begin
	ciudad_actual:= ubicacion_actual_persona (id_persona, fecha_actual);
	Begin
		Select lug.fk_lugar into pais_actual from lugar lug where lug.id = ciudad_actual and rownum<=1;
		EXCEPTION When NO_DATA_FOUND then pais_actual:=0;
	end;
	modelo:= obtener_modelo(pais_actual, fecha_actual);
	if modelo = 1 then
		prob:= 90;
	else
		prob:= 25;
	end if;
	Select trunc(dbms_random.value(1,100)) num into val From dual;
	if val <= prob then
		cant_gente:= calcular_gente_contacto (pais_actual);
		if modelo = 2 then
			cant_gente:= trunc(cant_gente*0.6);
		end if;
		contaux:=1;
		for contaux IN 1..cant_gente
		LOOP
			select min(per.id) into min_ciudad from persona per where per.fk_lugar = ciudad_actual;
			select max(per.id) into max_ciudad from persona per where per.fk_lugar = ciudad_actual;
			Select trunc(dbms_random.value(min_ciudad,max_ciudad)) num into peraux From dual;
			if personaSana(peraux) = 1 then
				Select trunc(dbms_random.value(1,15)) num into vval From dual;
				if vval <= 2 then
					dbms_output.put_line('La persona con id ' || id_persona || ' infectar� a la persona con id ' || peraux || ' en la ciudad ' ||  ciudad_actual || '.');
					Infectar (peraux, fecha_actual);
				end if;
			end if;
		end loop;
	end if;
end; 



Create or replace procedure Diario_CentroS (id_centroS number, fecha_actual date) is
    camas_ocupadas number;
    camas_totales number;
    camas_disponibles number;
    suma number;
    validar_insumo number;
    aux_estado number;
    pais number;
    prob number;
    pais_llegada number;
    clave_ayuda number;
    dinero number;
    contalej number;
begin

    begin
    select cs.camas_totales into camas_totales from centro_de_salud cs 
    where cs.id = id_centroS
    and rownum<=1;
    EXCEPTION when NO_DATA_FOUND then camas_totales:=0;
    end;

    begin
    select cs.camas_disponibles into camas_disponibles from centro_de_salud cs 
    where cs.id = id_centroS
    and rownum<=1;
    EXCEPTION when NO_DATA_FOUND then camas_disponibles:=0;
    end;

    camas_ocupadas := camas_totales - camas_disponibles;
    Select ceil(camas_totales*0.1) into suma From dual;

        Update Centro_de_salud_y_insumo centroIns SET centroIns.cantidad_insumo.cantidad = centroIns.cantidad_insumo.cantidad + suma - trunc(camas_ocupadas*1.25)
        where centroIns.fk_centrodeSalud = id_centroS;

    begin
    select centroIns.cantidad_insumo.cantidad into validar_insumo from Centro_de_salud_y_insumo centroIns
    where centroIns.fk_centrodeSalud = id_centroS
    and fk_insumo = 1;
    EXCEPTION when NO_DATA_FOUND then validar_insumo:=0;
    end;

    if (validar_insumo <= 0) then
        begin                                                       /*pais que recibe ayuda*/
            select cs.fk_lugar into aux_estado from centro_de_salud cs 
            where cs.id = id_centroS
            and rownum<=1;
        EXCEPTION when NO_DATA_FOUND then aux_estado:=0;
        end;

        begin
            select l.fk_lugar into pais_llegada from lugar l
            where l.id = aux_estado;

            EXCEPTION when NO_DATA_FOUND then pais_llegada:=0;
        end;
	dbms_output.put_line('----------------------------------------------------------------------------');
dbms_output.put_line('----------------------------------------------------------------------------');
	dbms_output.put_line('Insumos agotados en el centro de salud de id ' || id_centroS || ' ubicado en el pa�s con id ' || pais_llegada || '.');
	dbms_output.put_line('----------------------------------------------------------------------------');
dbms_output.put_line('----------------------------------------------------------------------------');
	contalej:=0;
	while contalej=0
	LOOP
        	Select trunc(dbms_random.value(1,15)) num into pais From dual;   /*pais que da la ayuda*/
		if pais != pais_llegada then
			contalej:=1;
		end if;
	end Loop;
        Select trunc(dbms_random.value(1,10)) num into prob From dual;
   
        if(prob<=5) then                 /*calcular dinero */
         dinero := 10000*camas_totales;
        else
         dinero := 0;
        end if;

            INSERT INTO Ayuda_humanitaria (cantidad_dinero, fechas_inicio_fin, fk_salida, fk_llegada) 
            VALUES (cantidad(dinero), fechas_inicio_fin(fecha_actual, fecha_actual+1), pais, pais_llegada);
dbms_output.put_line('----------------------------------------------------------------------------');
dbms_output.put_line('----------------------------------------------------------------------------');
	    dbms_output.put_line('Ayuda humanitaria solicitada por el pa�s de id ' || pais_llegada || ' al pa�s con id ' || pais || '.');
            begin            /*se ubica la ultima ayuda generada*/
            select ayuda.id into clave_ayuda from (select id from Ayuda_humanitaria order by id DESC) ayuda    
            where rownum<=1;
            EXCEPTION when NO_DATA_FOUND then clave_ayuda:=0;
            end;

            For cont IN 1..15
            LOOP
                INSERT INTO Ayuda_humanitaria_y_Insumo (cantidad_insumo, fk_ayuda, fk_insumo) VALUES (cantidad(camas_totales*2), clave_ayuda, cont);
            End loop;
	    dbms_output.put_line('La ayuda contiene ' || camas_totales*2 || ' unidades de cada insumo.');
                                                                        /*el mismo update pero con otra cantidad*/

            Update Centro_de_salud_y_insumo centroIns SET centroIns.cantidad_insumo.cantidad = camas_totales*2
            where centroIns.fk_centrodeSalud = id_centroS;
    end if;
end;

CREATE OR REPLACE PROCEDURE ingresarEnClinica(id_persona number, fecha_actual date) 
IS
    auxDias number;
    auxInfectado number;
    auxHospitalizado number;
    prob number;
    auxClinica number;
    auxCamas number;
BEGIN
    auxInfectado := personaInfectada(id_persona, fecha_actual);
    auxHospitalizado := personaHospitalizada(id_persona, fecha_actual);

    if (auxInfectado = 1 AND auxHospitalizado = 0) then
       auxDias:=calcular_dias_infeccion(id_persona, fecha_actual);
        
        if (auxDias = 10) then
            SELECT trunc(DBMS_RANDOM.VALUE(1,10)) num INTO prob FROM dual;

            if (prob <= 4) then
                BEGIN
                    SELECT c.id INTO auxClinica
                    FROM Centro_de_Salud c
                    WHERE c.fk_lugar = (SELECT p.fk_lugar FROM Persona p WHERE p.id = id_persona);
                    EXCEPTION when NO_DATA_FOUND then auxClinica := null;
                END;
                BEGIN
                    SELECT c.camas_disponibles INTO auxCamas
                    FROM Centro_de_Salud c
                    WHERE c.id = auxClinica;
                    EXCEPTION when NO_DATA_FOUND then auxCamas := null;
                END;

                if (auxCamas > 0) then
                    UPDATE Persona SET Tratado = 1, fk_centroS = auxClinica WHERE id = id_persona;
                    UPDATE Centro_de_Salud SET camas_disponibles = camas_disponibles - 1 WHERE id = auxClinica;
		    dbms_output.put_line('Persona de id  ' || id_persona  || ' ingresada en el centro de salud de id ' || auxClinica || '.');
		else
		    dbms_output.put_line('Camas agotadas en el centro de salud de id ' || auxClinica || '.');
                end if;
            end if;
        end if;
    end if;
END;



Create or replace procedure Simular (inicio_periodo date, fin_periodo date) is
valor number;
fecha_actual date;
cont number;
dias number;
id_pais number;
contaux number;
prob number;
varextra number;
begin
	dbms_output.enable(NULL);
	fecha_actual:= inicio_periodo;
	dias:= fin_periodo - inicio_periodo;
	Select trunc(dbms_random.value(1,2499)) num into valor From dual;
	Infectar (valor, fecha_actual);
	Select trunc(dbms_random.value(5252,5570)) num into valor From dual;
	Infectar (valor, fecha_actual);
    Select trunc(dbms_random.value(6130,7500)) num into valor From dual;
	Infectar (valor, fecha_actual);
	cont:=1;
	For cont IN 1..7519
	LOOP
		Select trunc(dbms_random.value(1,10)) num into prob From dual;
		if prob <= 3 then
			Agregar_patologias(cont);
		end if;
	End loop;
	cont:=1;
	FOR cont IN 1..dias
	LOOP
		Fecha_actual:= inicio_periodo + cont -1;
		dbms_output.put_line('----------------------------------------------------------------------------');
dbms_output.put_line('----------------------------------------------------------------------------');
dbms_output.put_line('----------------------------------------------------------------------------');
		dbms_output.put_line('INICIA EL D�A ' || fecha_actual || ' .');
dbms_output.put_line('----------------------------------------------------------------------------');
dbms_output.put_line('----------------------------------------------------------------------------');
dbms_output.put_line('----------------------------------------------------------------------------');
		contaux:=1;
		FOR contaux IN 1..15
		LOOP
			id_pais:=contaux;
			Cambiar_modelo (id_pais, fecha_actual);
		End Loop;
		contaux:=1;
		FOR contaux IN 1..15
		LOOP
			Crear_historico_internet (contaux, fecha_actual);
		End loop;
		Generar_vuelos(fecha_actual);
		contaux:= 1;
		For contaux IN 1..75
		LOOP
            		Diario_CentroS (contaux, fecha_actual);   
		End loop;
		Contaux:=1;
		For contaux IN 1..7519 
		LOOP
		if personaInfectada(contaux, fecha_actual) = 1 then
			varextra:= calcular_dias_infeccion(contaux, fecha_actual);
			if varextra = 10 then
			IngresarEnClinica (contaux, fecha_actual);            
				end if; 
			if varextra = 21 then
				Decidir_muerte_recuperacion (contaux, fecha_actual);
			end if;
			 if personaHospitalizada(contaux, fecha_actual) = 0 then
				Infeccion(contaux, fecha_actual);
			end if;
		end if;
		End loop;
	END LOOP;
end;

exec Simular (TO_DATE('08/01/2020', 'mm/dd/yyyy'), TO_DATE('09/15/2020', 'mm/dd/yyyy'));


 

