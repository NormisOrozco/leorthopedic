CREATE TABLE entradas (
	id_entrada INT PRIMARY KEY AUTO_INCREMENT, 
	id_producto INT NOT NULL, 
	cantidad INT, 
	costo FLOAT, 
	observaciones TEXT(100), 
	fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

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
	id_lapso INT NOT NULL,
	ubicacion TEXT(200));

CREATE TABLE lapsos (
 	id_lapso INT PRIMARY KEY AUTO_INCREMENT,
 	desc_lapso VARCHAR(45));

CREATE TABLE productos (
	id_producto INT PRIMARY KEY AUTO_INCREMENT, 
	codigo VARCHAR(45) UNIQUE NOT NULL,
	descripcion_p VARCHAR(45), 
	id_categoria INT NOT NULL, 
	precio_venta FLOAT NOT NULL, 
	precio_adq FLOAT NOT NULL, 
	minimo INT NOT NULL,
	existencias INT,
	ruta_img TEXT(200));


CREATE TABLE colores(
	id_color INT PRIMARY KEY AUTO_INCREMENT,
	desc_color VARCHAR(45));

CREATE TABLE categorias (
	id_categoria INT PRIMARY KEY AUTO_INCREMENT, 
	descripcion_c VARCHAR(45));

CREATE TABLE tickets (
	id_ticket INT PRIMARY KEY AUTO_INCREMENT, 
	cliente TEXT(100), 
	total FLOAT, 
	fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	procesado INT NOT NULL);

CREATE TABLE tallas (
	id_talla INT PRIMARY KEY AUTO_INCREMENT, 
	desc_talla VARCHAR(45));

CREATE TABLE ventas (
	id_venta INT PRIMARY KEY AUTO_INCREMENT, 
	id_producto INT NOT NULL, 
	cantidad INT DEFAULT 1, 
	id_ticket INT NOT NULL, 
	subtotal FLOAT NOT NULL);

CREATE TABLE clasificaciones(
	id_clasificacion INT PRIMARY KEY AUTO_INCREMENT,
	id_producto INT NOT NULL,
	tallas INT,
	generos INT,
	izqder INT,
	colores INT);

CREATE TABLE assign_tallas(
	id_assign_talla INT PRIMARY KEY AUTO_INCREMENT,
	id_clasificacion INT NOT NULL,
	id_talla INT NOT NULL,
	cantidad INT);

CREATE TABLE assign_colores(
	id_assign_color INT PRIMARY KEY AUTO_INCREMENT,
	id_clasificacion INT NOT NULL,
	id_color INT NOT NULL,
	cantidad INT);

CREATE TABLE assign_generos(
	id_assign_genero INT PRIMARY KEY AUTO_INCREMENT,
	id_clasificacion INT NOT NULL,
	genero INT NOT NULL,
	cantidad INT);

CREATE TABLE assign_izqder(
	id_assign_izqder INT PRIMARY KEY AUTO_INCREMENT,
	id_clasificacion INT NOT NULL,
	lado INT NOT NULL,
	cantidad INT);
=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:PROCEDIMIENTO PARA NUEVA ENTRADA 
DELIMITER //
CREATE PROCEDURE nva_ent(
  p_codigo VARCHAR(45),
  p_cant INT,
  p_costo FLOAT,
  p_observ TEXT(100)) 
BEGIN
DECLARE vid_prod INT;
	SELECT id_producto into vid_prod FROM productos WHERE  productos.codigo=p_codigo;
	IF p_cant<=0
		then
		SELECT('LA CANTIDAD DE PRODUCTOS NO ES CORRECTA.' AS error);
		else
			IF p_costo<=0
				then
				SELECT( 'EL COSTO DE PRODUCTO NO ES CORRECTO.' AS error);
				else
				IF vid_prod=NULL
					then
					SELECT('ESE PRODUCTO NO ESTÁ REGISTRADO.' AS error);
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

# para hace runa venta se deben ingresar los datos principales y luego clasificar el producto ara restarle la cantidad a determinado conjunto de clasificaciones
# esto se hace con el siguiente procedeimiento

DELIMITER//
CREATE PROCEDURE get_id_atributo(
	p_codigo VARCHAR(45),
	pid_talla INT,
	p_genero INT,
	p_izq_der INT,
	pid_color INT,
	cantidad INT)
BEGIN
DECLARE vid_prod INT;
SELECT id_producto into vid_prod from productos WHERE codigo=p_codigo;
SELECT id_atributo from atributos WHERE 
	id_producto=vid_prod AND 
	id_talla=pid_talla AND 
	genero=p_genero AND 
	izq_der=p_izq_der AND
	id_color=pid_color;
	END;

#una vez obtenido el id de CLASIFICACIÓN SE PROCEDE A EJECUTAR EL PROCEDIMIENTO DE GENERACIÓN DE ENETRADAS


DELIMITER //
CREATE PROCEDURE nva_venta(
  p_codigo VARCHAR(45),
  p_cantidad INT,
  pid_atributo INT)
BEGIN
DECLARE vid_prod INT;
DECLARE v_prod INT;
DECLARE v_precio FLOAT;
DECLARE v_subtotal FLOAT;
DECLARE v_ticket INT;
DECLARE v_disponibles INT;
DECLARE v_codigo INT;
SET vid_prod=0;
SET v_precio=0;
SET v_subtotal=0;
SET v_ticket=0;
SET v_disponibles=0;
SET v_codigo=0;
	SELECT id_producto into vid_prod FROM productos WHERE  productos.codigo=p_codigo;

	SELECT COUNT(ventas.id_producto) as v_codigo from productos, ventas where ventas.id_producto=productos.id_producto AND productos.codigo=p_codigo and id_ticket=v_ticket;
	IF v_codigo>0
	then
		UPDATE ventas set cantidad=cantidad+p_cantidad where id_producto=vid_prod;
	else
		IF vid_prod=NULL
			then
			SELECT('ESE PRODUCTO NO ESTÁ REGISTRADO.' AS error);
			else
				IF p_cantidad<=0
					then
					SELECT('LA CANTIDAD DE PRODUCTOS NO ES CORRECTA.' AS error);
					else
						SELECT existencias into v_disponibles from productos where id_producto=vid_prod;
						IF p_cantidad>v_disponibles
						then
						SELECT('NO HAY SUFICIENTES PRODUCTOS.' AS error);
						else
							UPDATE atributos set cantidad=cantidad-v_cantidad where id_atributo=pid_atributo; #SE ACTUALIZA LA CANTIDAD EN LA CLASIFICACIÓN CORRESPONDIENTE
							SELECT precio_venta into v_precio from productos where vid_prod=productos.id_producto;
							SET v_subtotal=v_precio*p_cantidad;
						  	SELECT id_ticket into v_ticket from tickets order by id_ticket desc LIMIT 1; #SE OBTIENE EL TIQUET, QUE PÓR LÓGICA ES EL ÚLTIMO AGREGADO
						  	INSERT INTO ventas VALUES(NULL, vid_prod, p_cantidad, v_ticket, v_subtotal); #SE INSERTA EL REGISTRO EN LA TABLA DE VENTAS
						  	UPDATE productos set existencias=existencias-p_cantidad where id_producto=vid_prod; #SE RESTA LA EXISTENCIA EN LA TABLA DE PRODUCTOS
		  					SELECT ('VENTA GENERADA CON ÉXITO.');	
		  				end if;
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
	p_precio FLOAT,
	p_minimo INT,
	pruta_img TEXT(200)) #minimo que debería haber en Stock
BEGIN
DECLARE vid_prod INT;
DECLARE v_codigo VARCHAR(45);
DECLARE vid_catego INT;
	SELECT id_categoria into vid_catego from categorias where descripcion_c LIKE p_categoria;
	IF vid_catego=NULL
		then
		SELECT('LA CATEGORIA NO ES CORRECTA.') AS error;
		else
			IF p_desc=''
				then
				SELECT('LA DESCRIPCIÓN NO ES CORRECTA.') AS error;
				else
					IF p_precio=0
						then
						SELECT('EL COSTO NO PUEDE SER NULO') AS error;
						else
							SELECT count(codigo) into v_codigo from productos where p_codigo=codigo;
							IF v_codigo>0
								then
								SELECT('ESE CÓDIGO YA EXISTE.') AS error;
								else
									IF p_codigo is null
										then
										SELECT('DEBE EXISTIR UN CÓDIGO PARA EL PRODUCTO.') AS error;
										else
											INSERT INTO productos VALUES(NULL, p_codigo, p_desc, vid_catego, p_precio, 0, p_minimo, 0, pruta_img);
											SELECT ('NUEVO PRODUCTO REGISTRADO.');
											
									end if;
							end if;
					end if;
			end if;
	end if;
END;

#después de haber registrado un nuevo producto será necesario clasificarlo en tallas, generos, colores, etc.

CREATE PROCEDURE clasificar(
	p_codigo VARCHAR(45),
	pid_talla INT,
	p_genero INT,
	p_izq_der INT,
	pid_color INT)
BEGIN
DECLARE vid_prod INT;
	SELECT id_producto into vid_prod from productos where codigo=p_codigo; #SE OBTIENE EL ID DEL PRODUCTO
	INSERT INTO atributos values (null, vid_prod, pid_talla, p_genero, p_izq_der, pid_color, cantidad); #SE INSERTA UN REGISTRO EN LA TABLA DE ATRIBUTOS
END;



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
		SELECT('LA TALLA ESPECIFICADA NO EXISTE.' AS error);
		else
			SELECT count(id_producto) into vid_prod from productos where id_producto=pid_prod;
			IF vid_prod<=0
			then
				SELECT('EL PRODUCTO ESPECIFICADO NO EXISTE.' AS error);
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
		SELECT('INGRESE UNA DESCRIPCIÓN PARA LA NUEVA TALLA.' AS error);
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
		SELECT('INGRESE UNA DESCRIPCIÓN PARA LA NUEVA CATEGORIA.' AS error);
		else
			INSERT INTO categorias VALUES(NULL, pdescripcion_c);
			SELECT('NUEVA CATEGORIA REGISTRADA.');
	end if;
END;


=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:PROCEDIMIENTO PARA  REALIZAR UNA CANCELACION

DELIMITER //
CREATE PROCEDURE nva_cancel()
BEGIN
DECLARE vid_ticket INT;
 	SELECT id_ticket into vid_ticket from tickets order by id_ticket desc limit 1;
 	DELETE from ventas where id_ticket=v_ticket; #elimina todas las ventas que corresponden al ticket
 	update tickets set procesado="3" where id_ticket=vid_ticket; #pasa el ticket a un estado de cancelación
 	SELECT ("CANCELADO");
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
			SELECT('DATOS DE CÓDIGO O FOLIO INCORRECTOS, VERIFIQUE.' AS error);
		else
			IF v_cantidad<=p_cantidad
			then
				UPDATE ventas set cantidad=cantidad-v_cantidad where id_ticket=pid_ticket and id_producto=vid_prod; #E RESTA LA CANTIDAD DE´PRODUCTOS DEVUELTOS A LA VENTA QUE SE REALIZO
				UPDATE productos set existencias=existencias+p_cantidad where  productos.id_producto=vid_prod; # SE AGREGAN LA CANTIDAD DE ARTICULOS AL IVENTARIO
				SELECT precio_venta*p_cantidad into v_subtotal from productos, ventas, tickets where   productos.codigo=p_codigo and productos.id_producto=ventas.id_producto and ventas.id_ticket=pid_ticket; #SE OBTIENE CUÁNTO SE LE HA DE REGRESAR AL CLIENTE
				SELECT ('DEVOLUCIÓN PROCESADA, ENTREGUE AL CLIENTE LA CANTIDAD DE $'+v_subtotal+' PESOS.');
			else
				SELECT('ESA CANTIDAD DE PRODUCTOS A DEVOLVER NO ES CORRECTA.' AS error);
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
		SELECT('LA CANTIDAD DE PRODUCTOS NO ES CORRECTA.' AS error);
		else
			SELECT id_producto into vid_prod FROM ventas WHERE  ventas.id_venta=pid_venta;
			UPDATE productos set existencias=existencias+v_cantantes where id_producto=vid_prod;
			SELECT existencias into v_disponbles from productos where id_producto=vid_prod;
			IF p_cantidad>v_disponbles
				then
				SELECT('LA CANTIDAD EXCEDE LA DISPONIBILIDAD.' AS error);
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
	productos.id_producto as id,
	productos.codigo as codigo,
	productos.descripcion_p as producto,
	tallas.desc_talla as talla,
	productos.precio_venta as precio,
	productos.existencias as disponibles
FROM 
	productos, clasificaciones, assign_tallas, tallas, categorias
WHERE
	productos.id_producto=clasificaciones.id_producto and
	clasificaciones.id_clasificacion=assign_tallas.id_clasificacion and
	assign_tallas.id_talla=tallas.id_talla and
	productos.id_categoria=categorias.id_categoria
	);

#VISTA QUE OBTIENE LOS PRODUCTOS POR AGOTARSE SIN DETALLES
CREATE VIEW vista_pagot as(
SELECT 
	CONCAT(productos.descripcion_p,CONCAT(" ",tallas.desc_talla)) as descripcion,
	productos.existencias as disponibles
FROM
	productos, clasificaciones, assign_tallas, tallas, categorias
WHERE
	productos.id_producto=clasificaciones.id_producto and
	clasificaciones.id_clasificacion=assign_tallas.id_clasificacion and 
	assign_tallas.id_talla=tallas.id_talla and
	productos.id_categoria=categorias.id_categoria and
	productos.existencias<=productos.minimo
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
