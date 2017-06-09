CREATE TABLE entradas (
	id_entrada INT PRIMARY KEY AUTO_INCREMENT, 
	id_producto INT NOT NULL, 
	cantidad INT DEFAULT 1, 
	costo FLOAT DEFAULT 0, 
	observaciones TEXT(100), 
	fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE TABLE rutas_catalogo(
	id_ruta_catalogo INT PRIMARY KEY AUTO_INCREMENT, 
	id_producto INT NOT NULL, 
	ruta TEXT(255) NOT NULL);

CREATE TABLE cortes(
	id_corte INT PRIMARY KEY AUTO_INCREMENT,
	fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	supuesto FLOAT NOT NULL,
	realidad FLOAT NOT NULL, 
	ubicacion TEXT(200));

CREATE TABLE reportes(
	id_reporte INT PRIMARY KEY AUTO_INCREMENT,
	fecha_i DATE,
	fecha_f DATE,
	tipo INT NOT NULL,
	ubicacion TEXT(200));

CREATE TABLE lapsos (
 	id_lapso INT PRIMARY KEY AUTO_INCREMENT,
 	descripcion VARCHAR(45));

CREATE TABLE productos (
	id_producto INT PRIMARY KEY AUTO_INCREMENT, 
	codigo VARCHAR(45) UNIQUE NOT NULL,
	descripcion_p VARCHAR(45), 
	id_categoria INT NOT NULL, 
	precio_venta FLOAT NOT NULL, 
	precio_adq FLOAT NOT NULL, 
	minimo INT NOT NULL,
	existencias INT);

CREATE TABLE categorias (
	id_categoria INT PRIMARY KEY AUTO_INCREMENT, 
	descripcion_c VARCHAR(45));

CREATE TABLE tickets (
	id_ticket INT PRIMARY KEY AUTO_INCREMENT, 
	cliente TEXT(100), 
	total FLOAT, 
	fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	procesado INT NOT NULL);

CREATE TABLE tallasprods (
	id_tallaprod INT PRIMARY KEY AUTO_INCREMENT, 
	id_producto INT NOT NULL, 
	id_talla INT NOT NULL);

CREATE TABLE tallas (
	id_talla INT PRIMARY KEY AUTO_INCREMENT, 
	desc_talla VARCHAR(45));

CREATE TABLE ventas (
	id_venta INT PRIMARY KEY AUTO_INCREMENT, 
	id_producto INT NOT NULL, 
	cantidad INT DEFAULT 1, 
	id_ticket INT NOT NULL, 
	subtotal FLOAT NOT NULL);


=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:PROCEDIMIENTO PARA NUEVA ENTRADA 
DELIMITER //
CREATE PROCEDURE nva_ent(
  p_codigo INT,
  p_cant INT,
  p_costo FLOAT,
  p_observ TEXT(100))
BEGIN
DECLARE vid_prod INT;
	SELECT id_producto into vid_prod FROM productos WHERE  productos.codigo=p_codigo;
	IF p_cant<=0
		then
		signal sqlstate '45000' set message_text ='LA CANTIDAD DE PRODUCTOS NO ES CORRECTA.';
		else
			IF p_costo<=0
				then
				signal sqlstate '45000' set message_text = 'EL COSTO DE PRODUCTO NO ES CORRECTO.';
				else
				IF vid_prod=NULL
					then
					signal sqlstate '45000' set message_text ='ESE PRODUCTO NO ESTÁ REGISTRADO.';
					else
						  INSERT INTO entradas VALUES(NULL, vid_prod, p_cant, p_costo, p_observ, NULL);
						  UPDATE productos set existencias=existencias+p_cant WHERE productos.codigo=p_codigo;
						  SELECT ('NUEVA ENTRADA REGISTRADA.');
				end if;
		end if;
	end if;
END;


#CREADO 

se llama 

call nva_ent(1, 2, 20, "Caja rota");


=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:PROCEDIMIENTO PARA UN NUEVO TICKET
DELIMITER //
CREATE PROCEDURE nvo_ticket(
  p_cliente TEXT)
BEGIN
  INSERT INTO tickets VALUES(NULL, p_cliente, 0, NULL, 0);
  SELECT ('OK');
END;
#CREADO
call nva_ent("Marco Alejandro"); #SE MANDA EL NOMBRE OBTENIDO POR EL FORMULARIO

=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=: PROCEDIMIENTO PARA HACER UNA VENTA

DELIMITER //
CREATE PROCEDURE nva_venta(
  p_codigo VARCHAR(45),
  p_cantidad INT)
BEGIN
DECLARE vid_prod INT;
DECLARE v_prod INT;
DECLARE v_precio FLOAT;
DECLARE v_subtotal FLOAT;
DECLARE v_ticket INT;
DECLARE v_disponibles INT;
SET vid_prod=0;
SET v_precio=0;
SET v_subtotal=0;
SET v_ticket=0;
SET v_disponibles=0;
	SELECT id_producto into vid_prod FROM productos WHERE  productos.codigo=p_codigo;
	IF vid_prod=NULL
		then
		signal sqlstate '45000' set message_text ='ESE PRODUCTO NO ESTÁ REGISTRADO.';
		else
			IF p_cantidad<=0
				then
				signal sqlstate '45000' set message_text ='LA CANTIDAD DE PRODUCTOS NO ES CORRECTA.';
				else
					SELECT existencias into v_disponibles from productos where id_producto=vid_prod;
					IF p_cantidad>v_disponibles
					then
					signal sqlstate '45000' set message_text='LA CANTIDAD EXCEDE LA DISPONIBILIDAD.';
					else
						SELECT precio_venta into v_precio from productos where vid_prod=productos.id_producto;
						SET v_subtotal=v_precio*p_cantidad;
					  	SELECT id_ticket into v_ticket from tickets order by id_ticket desc LIMIT 1;
					  	INSERT INTO ventas VALUES(NULL, vid_prod, p_cantidad, v_ticket, v_subtotal);
					  	UPDATE productos set existencias=existencias-p_cantidad where id_producto=vid_prod;
	  					SELECT ('OK');	
	  				end if;
  			end if;
  	end if;
END;

#CREADO


=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=PROCEDIMIENTO PARA TERMINAR UNA VENTA

DELIMITER //
CREATE PROCEDURE ter_venta()
BEGIN
DECLARE vid_ticket INT;
DECLARE v_total FLOAT;
	SELECT id_ticket into vid_ticket from tickets order by id_ticket desc LIMIT 1; #SE OBTIENE EL ÚLTIMO TICKET
	SELECT SUM(subtotal) into v_total FROM ventas WHERE id_ticket=vid_ticket; #SE OBTIENE EL TOTAL DE LA VENTA QUE ESTÁ REGISRADA CON ESE TICKET
	UPDATE tickets set total=v_total where id_ticket=vid_ticket; # SE AGREGA EL TOTAL DE LA VENTA AL TICKET
	UPDATE tickets set fecha=NULL where id_ticket=vid_ticket; # SE ACTUALIZA LA FECHA DE EMISIÓN DEL TICKET
	UPDATE tickets set procesado=1 where id_ticket=vid_ticket; # INDICA QUE EL TICKET HA SIDO PROCESADO.
END;

#CREADO


=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=PROCEDIMIENTO PARA REGISTRAR UN NUEVO PRODUCTO

DELIMITER //
CREATE PROCEDURE nvo_prod(
	p_codigo VARCHAR(45), #Se ecesita un código de barras
	p_desc VARCHAR(45), #descripcion
	p_categoria VARCHAR(45), #una categoria
	p_talla VARCHAR(45),
	p_cantidad INT, #una cantidad de productos entrantes
	p_costo FLOAT, # el costo del total de los productos entrantes
	p_obs TEXT(100), #observaciones de la entrada
	p_minimo INT) #minimo que debería haber en Stock
BEGIN
DECLARE vid_prod INT;
DECLARE vid_talla INT;
DECLARE v_codigo VARCHAR(45);
DECLARE v_pa FLOAT;
DECLARE v_pv FLOAT;
DECLARE vid_catego INT;
	SELECT id_categoria into vid_catego from categorias where descripcion_c LIKE p_categoria;
	IF vid_catego=NULL
		then
		signal sqlstate '45000' set message_text='LA CATEGORIA NO ES CORRECTA.';
		else
			IF p_desc=''
				then
				signal sqlstate '45000' set message_text='LA DESCRIPCIÓN NO ES CORRECTA.';
				else
					IF p_cantidad<=0
						then
						signal sqlstate '45000' set message_text='LA CANTIDAD NO PUEDE SER NULA.';
						else
							IF p_costo=0
								then
								signal sqlstate '45000' set message_text='EL COSTO NO PUEDE SER NULO';
								else
									SELECT count(codigo) into v_codigo from productos where p_codigo=codigo;
									IF v_codigo>0
										then
										signal sqlstate '45000' set message_text='ESE CÓDIGO YA EXISTE.';
										else
											IF p_codigo=''
												then
												signal sqlstate '45000' set message_text='DEBE EXISTIR UN CÓDIGO PARA EL PRODUCTO.';
												else
													SELECT id_talla into vid_talla FROM tallas where tallas.desc_talla LIKE p_talla;
													IF vid_talla=NULL 
														then
															signal sqlstate '45000' set message_text='LA TALLA NO ES VÁLIDA.';
														else
															INSERT INTO productos VALUES(NULL, p_codigo, p_desc, vid_catego, 0, 0, p_minimo, p_cantidad);
															SELECT id_producto into vid_prod from productos where codigo=p_codigo;
															INSERT into tallasprods VALUES(NULL, vid_prod, vid_talla);
															INSERT INTO entradas VALUES(NULL, vid_prod, p_cantidad, p_costo, p_obs, NULL);
															SET v_pa=p_costo/p_cantidad;
															UPDATE productos set precio_adq=v_pa where id_producto=vid_prod;
															SET v_pv=v_pa+(v_pa*.20);
															UPDATE productos set precio_venta=v_pv where id_producto=vid_prod;
															SELECT ('NUEVO PRODUCTO REGISTRADO.');
													end if;
											end if;
									end if;
							end if;
					end if;
			end if;
	end if;
END;
#CREADO


=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:PROCEDIMIENTO PARA REGISTRAR PRODUCTOS Y TALLAS 

DELIMITER //
CREATE PROCEDURE prod_tallas(
	pid_prod INT, 
	pid_talla INT)
BEGIN
DECLARE vid_talla INT;
DECLARE vid_prod INT;
	SELECT count(id_talla) into vid_talla from tallas where id_talla=pid_talla;
	IF vid_talla<=0 
	then
		signal sqlstate '45000' set message_text='LA TALLA ESPECIFICADA NO EXISTE.';
		else
			SELECT count(id_producto) into vid_prod from productos where id_producto=pid_prod;
			IF vid_prod<=0
			then
				signal sqlstate '45000' set message_text='EL PRODUCTO ESPECIFICADO NO EXISTE.';
				else
					INSERT INTO tallasprods VALUES(NULL, pid_prod, pid_talla);
					SELECT ('PRODUCTO EN TALLA REGISTRADO');
			end if;
	end if;
END;

#CREADO

=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:PROCEDIMIENTO PARA REGISTRAR UNA NUEVA TALLA

DELIMITER //
CREATE PROCEDURE nva_talla(
	pdesc_talla VARCHAR(45))
BEGIN
	IF pdesc_talla=''
	then
		signal sqlstate '45000' set message_text='INGRESE UNA DESCRIPCIÓN PARA LA NUEVA TALLA.';
		else
			INSERT INTO tallas VALUES(NULL, pdesc_talla);
	end if;
END;

#CREADO

=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:PROCEDIMIENTO PARA REGISTRAR UNA NUEVA CATEGORIA

DELIMITER //
CREATE PROCEDURE nva_catego(
	pdescripcion_c VARCHAR(45))
BEGIN
	IF pdescripcion_c=''
	then
		signal sqlstate '45000' set message_text='INGRESE UNA DESCRIPCIÓN PARA LA NUEVA CATEGORIA.';
		else
			INSERT INTO categorias VALUES(NULL, pdescripcion_c);
			SELECT('NUEVA CATEGORIA REGISTRADA.');
	end if;
END;


=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:PROCEDIMIENTO PARA  REALIZAR UNA CANCELACION

DELIMITER //
CREATE PROCEDURE nva_cancel (
	pid_venta INT)
BEGIN
 	
	delete from ventas WHERE ventas.id_venta=pid_venta;
END;

#CREADO


=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:PROCEDIMIENTO PARA  REALIZAR UNA DEVOLUCION

DELIMITER //
CREATE PROCEDURE nva_devol (
	p_codigo INT, 
	p_cantidad INT,
	pid_ticket INT,
	p_causa TEXT(200))
BEGIN
 	DECLARE vid_prod INT;
 	DECLARE v_cantidad INT;
 	DECLARE v_subtotal FLOAT;
SELECT id_producto into vid_prod FROM productos, ventas, tickets WHERE  productos.codigo=p_codigo and productos.id_producto=ventas.id_producto and ventas.id_ticket=pid_ticket;
SELECT cantidad into v_cantidad FROM productos, ventas, tickets WHERE  productos.id_producto=vid_prod and productos.id_producto=ventas.id_producto and ventas.id_ticket=pid_ticket;
	IF vid_prod=NULL
		then
			signal sqlstate '45000' set message_text ='DATOS DE CÓDIGO O FOLIO INCORRECTOS, VERIFIQUE.';
		else
			IF v_cantidad<=p_cantidad
			then
				UPDATE ventas set cantidad=cantidad-v_cantidad where id_ticket=pid_ticket and id_producto=vid_prod; #E RESTA LA CANTIDAD DE´PRODUCTOS DEVUELTOS A LA VENTA QUE SE REALIZO
				UPDATE productos set existencias=existencias+p_cantidad where  productos.id_producto=vid_prod; # SE AGREGAN LA CANTIDAD DE ARTICULOS AL IVENTARIO
				SELECT precio_venta*p_cantidad into v_subtotal from productos, ventas, tickets where   productos.codigo=p_codigo and productos.id_producto=ventas.id_producto and ventas.id_ticket=pid_ticket; #SE OBTIENE CUÁNTO SE LE HA DE REGRESAR AL CLIENTE
				SELECT ('DEVOLUCIÓN PROCESADA, ENTREGUE AL CLIENTE LA CANTIDAD DE $'+v_subtotal+' PESOS.');
			else
				signal sqlstate '45000' set message_text='ESA CANTIDAD DE PRODUCTOS A DEVOLVER NO ES CORRECTA.';
			end if;
	end if;
END;

#CREADO


=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:PROCEDIMIENTO PARA MODIFICAR LA CANTIDAD DE PRODUCTOS EN UNA VENTA


CREATE PROCEDURE mod_cantventa(
	pid_venta INT,
	p_cantidad INT)
BEGIN
	DECLARE v_disponbles INT;
	DECLARE vid_prod INT;
	DECLARE v_cantantes INT;
	DECLARE v_preciovta FLOAT;
	SELECT cantidad into v_cantantes from ventas where id_venta=pid_venta;
	IF p_cantidad<=0
		then
		signal sqlstate '45000' set message_text ='LA CANTIDAD DE PRODUCTOS NO ES CORRECTA.';
		else
			SELECT id_producto into vid_prod FROM ventas WHERE  ventas.id_venta=pid_venta;
			UPDATE productos set existencias=existencias+v_cantantes where id_producto=vid_prod;
			SELECT existencias into v_disponbles from productos where id_producto=vid_prod;
			IF p_cantidad>v_disponbles
				then
				signal sqlstate '45000' set message_text='LA CANTIDAD EXCEDE LA DISPONIBILIDAD.';
				else
					UPDATE ventas SET cantidad=p_cantidad WHERE id_venta=pid_venta;
					SELECT precio_venta into v_preciovta FROM productos where id_producto=vid_prod;
					UPDATE ventas set subtotal=p_cantidad*v_preciovta;
					UPDATE productos set existencias=existencias-p_cantidad where id_producto=vid_prod;
			end if;
	end if;
END;

#CREADO


=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:PROCEDIMIENTO PARA EDITAR UN PRODUCTO


CREATE PROCEDURE mod_prod(
	p_codigo VARCHAR(45),
	p_descripcion VARCHAR(45),
	p_categoria VARCHAR(45),
	p_talla VARCHAR(45),
	p_minimo INT)
BEGIN
	DECLARE vid_catego INT;
	DECLARE vid_talla INT;
	DECLARE vid_prod INT;
	SELECT id_categoria into vid_catego from categorias WHERE descripcion_c LIKE p_categoria;
	SELECT id_talla into vid_talla FROM tallas WHERE desc_talla LIKE p_talla;
	SELECT id_producto into vid_prod FROM productos WHERE  productos.codigo=p_codigo;
		UPDATE productos SET descripcion_p=p_descripcion, id_categoria=vid_catego, minimo=p_minimo WHERE id_producto=vid_prod;
		UPDATE tallasprods SET id_talla=vid_talla WHERE id_producto=vid_prod;
END;

:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:= BITÁCORAS :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=


#despues de haber agregado un nuevo producto
CREATE TABLE bit_nvosprods (
	idbit_np INT PRIMARY KEY AUTO_INCREMENT, 
	cuando TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
	id_producto INT NOT NULL, 
	preciou FLOAT NOT NULL, 
	cantidad INT, 
	subtotal FLOAT);

#Antes de una eliminación en la tabla de productos
CREATE TABLE bit_bajas(
	idbit_baja INT PRIMARY KEY AUTO_INCREMENT,
	cuando TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	producto VARCHAR(45) NOT NULL,
	por_que VARCHAR(100) NOT NULL DEFAULT "NA",
	valor FLOAT);

#Después de hacer un corte de caja
CREATE TABLE bit_cortesmal(
	idbit_cortemal INT PRIMARY KEY AUTO_INCREMENT,
	cuando TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	faltante FLOAT NOT NULL,
	justificado INT NOT NULL DEFAULT 0);

#Ates de realizar la cancelación
CREATE TABLE bit_cancelaciones(
	idbit_cancv INT PRIMARY KEY AUTO_INCREMENT,
	cuando TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	producto VARCHAR(45),
	cuantos INT NOT NULL,
	valor FLOAT NOT NULL,
	cliente VARCHAR(45));

#Ates de realizar la devolucion
CREATE TABLE bit_devoluciones(
	idbit_dev INT PRIMARY KEY AUTO_INCREMENT,
	cuando TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	producto VARCHAR(45),
	cuantos INT NOT NULL,
	valor FLOAT NOT NULL,
	cliente VARCHAR(45),
	por_que VARCHAR(100));

CREATE TRIGGER bit_nvosprods
	after INSERT on productos
	for each row
	BEGIN
	DECLARE v_subtotal;
	SET v_subtotal=(new.precio_adq)*(new.existencias);
	insert into bit_nvosprods VALUES(NULL, NULL, new.id_producto, new.precio_adq, new.existencias, v_subtotal);
	END;

CREATE TRIGGER bbp #BITACORA DE BAJA DE PRODUCTOS
	before DELETE on productos
	for each row
	BEGIN
	SET v_valor=old.precio_adq*old.existencias;
	insert into bit_bajas VALUES(NULL, NULL, old.descripcion_p, NULL, v_valor);
	END bbp;

CREATE TRIGGER bcm #BITACORA DE CORTES DE CAJA MAL EQUILIBRADOS
	after INSERT on cortes
	for each row
	BEGIN
	insert into bit_cortesmal VALUES(NULL, NULL, old.descripcion_p, NULL, old.precio_adq);
	END bcm;

CREATE TRIGGER bcanc{ #BITACORA DE CANCELACIONES
	before delete on ventas
	for each row
	BEGIN
}

CREATE TRIGGER bcanc #BITACORA DE DEVOLUCIONES
	before DELETE on ventas
	for each row
	BEGIN
	DECLARE vid_prod INT;
 	DECLARE v_cantidad INT;
 	SELECT cantidad into v_cantidad from ventas WHERE id_venta=old.id_venta;
 	SELECT id_producto into vid_prod FROM productos, ventas WHERE productos.id_producto=ventas.id_producto and ventas.id_venta=old.id_venta;
	UPDATE productos set existencias=existencias+v_cantidad where productos.id_producto=vid_prod; # SE AGREGAN LA CANTIDAD DE ARTICULOS AL IVENTARIO
end;


:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:= VISTAS :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=

#VISTA QUE OBTIENE LOS DATOS DE PRODUCTOS EN UNA VENTA EN EL ORDEN (codigo, producto, precio, cantidad, subtotal, id_venta) en función del ultimo ticket creado
CREATE VIEW show_ventas as(
	SELECT 
		codigo, 
		CONCAT(productos.descripcion_p, CONCAT(" ", tallas.desc_talla)) as producto, #SE CONCATENA EL PRODUCTO Y SU TALLA
		precio_venta as precio, 
		ventas.cantidad as cantidad, 
		ventas.subtotal as subtotal,
		id_venta
	FROM 
		productos,
		tallasprods,
		tallas,
		ventas
	WHERE 
		productos.id_producto=tallasprods.id_producto and
		tallas.id_talla=tallasprods.id_talla and
		productos.id_producto=ventas.id_producto and
		ventas.id_ticket=(SELECT id_ticket from tickets order by id_ticket desc LIMIT 1)
);

#VISTA QUE MUESTRA ID_PRODUCTO, NOMBRE, CANTIDAD, FECHA, OBSERACIONES
CREATE VIEW v_entradas as(
SELECT 
	id_producto, 
	descripcion_p as 'producto',
	entradas.cantidad as 'cantidad',
	entradas.fecha as 'fecha',
	entradas.observaciones as observaciones
FROM
	productos,
	entradas
WHERE
	entradas.id_producto=productos.id_producto);

#VISTA QUE OBTIENE DATOS DE PRODUCTOS EN EL ORDEN CODIGO PRODUCTO, TALLA, PRECIO, DISPONIBLES

CREATE VIEW vista_productos as(
SELECT
	productos.codigo as codigo,
	productos.descripcion_p as producto,
	tallas.desc_talla as talla,
	productos.precio_venta as precio,
	productos.existencias as disponibles
FROM 
	productos, tallasprods, tallas, categorias
WHERE
	productos.id_producto=tallasprods.id_producto and
	tallasprods.id_talla=tallas.id_talla and
	productos.id_categoria=categorias.id_categoria
	);

#VISTA QUE OBTIENE LOS PRODUCTOS POR AGOTARSE SIN DETALLES
CREATE VIEW vista_pagot as(
SELECT 
	CONCAT(productos.descripcion_p,CONCAT(" ",tallas.desc_talla as talla)) as descripcion,
	productos.existencias as disponibles
FROM
	productos, tallasprods, tallas, categorias
WHERE
	productos.id_producto=tallasprods.id_producto and
	tallasprods.id_talla=tallas.id_talla and
	productos.id_categoria=categorias.id_categoria and
	productos.existencias<=productos.minimo;
	);

#VISTA QUE OBTIENE LOS DATOS DE LAS ENTRADAS EN ORDEN PRODUCTO, CANTIDAD, FECHA, OBSERVACIONES
CREATE VIEW vista_entradas as(
SELECT 
	productos.descripcion_p as producto,
	entradas.cantidad as cantidad,
	entradas.fecha as fecha,
	entradas.observaciones as observaciones
FROM
	productos, entradas
WHERE
	productos.id_producto=entradas.id_producto
	);

#VISTA QUE OBTIENE DATOS DE PRODUCTOS EN EL ORDEN CODIGO PRODUCTO, CATEGORIA, TALLA, PRECIO, MINIMO

CREATE VIEW vista_editproductos as(
SELECT
	productos.codigo as codigo,
	productos.descripcion_p as producto,
	categorias.descripcion_c as categoria,
	tallas.desc_talla as talla,
	productos.minimo as minimo
FROM 
	productos, tallasprods, tallas, categorias
WHERE
	productos.id_producto=tallasprods.id_producto and
	tallasprods.id_talla=tallas.id_talla and
	productos.id_categoria=categorias.id_categoria
	);
