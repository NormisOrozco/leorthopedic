<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/style.css">
	<link rel="stylesheet" href="css/fonts.css">
	<link rel="stylesheet" href="css/bootstrap.css">
	<script type="text/javascript" src="js/script.js"></script>
	<script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="js/bootstrap.js"></script>
	<script type="text/javascript" src="js/jquery.validate.js"></script>
	<title>PRODUCTOS EN STOCK</title>
</head>
<body>
<nav>
	<?php
	require_once("menu.php");
	?>
</nav>
	
	<div class="divtop">
		<label for="" >PRODUCTOS EN STOCK</label>
	</div>
	<div  id="divprods">
		<div id="apuno">
			<div>
				<label for="" id="lbl_titulo">Detalles de productos en la tienda</label>
				<div id="in_search"><input type="text" placeholder=Buscar> <span class="icon-search"></span></div>
			</div>
			<hr>
			<label for="">Todos los productos</label>
			<table id="tabla_productos">
				<tr>
					<th class="tit_col">Producto</th>
					<th class="tit_col">Talla <a id="btn_addtalla" href='#' class="btn btn-success"><span class="glyphicon glyphicon-plus"></span></a></th>
					<th class="tit_col">Precio</th>
					<th class="tit_col">Disponibles</th>
					<th class="tit_col" style="width: 4em;">Editar</th>
				</tr>
				<tr>
					<td class="campo"></td>
					<td class="campo"></td>
					<td class="campo"></td>
					<td class="campo"></td>
					<td class="campo">
						<a href='#' class="btn_editprod">
							<span class="btn btn-primary glyphicon glyphicon-pencil"></span>
						</a>
					</td>
				</tr>
			</table>
		</div>
		<div id="apdos">
			<div id="divprods2">
				<label for="">Productos por agotarse</label>
				<table id="tabla_productosw">
					<tr>
						<th class="tit_col">Descripción</th>
						<th class="tit_col">Disponibles</th>
						<th class="tit_col" style="width: 5em;">Detalles</th>
					</tr>
					<tr>
						<td class="camposwar">Muñequera</td>
						<td class="camposwar">2</td>
						<td class="camposwar"><a href='!#' class="btn_deta"><span class='btn btn-warning icon-info'></span></a></td>
					</tr>
					<tr>
						<td class="camposwar"></td>
						<td class="camposwar"></td>
					</tr>
					<tr>
						<td class="camposwar"></td>
						<td class="camposwar"></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<aside id="container_modal"></aside>
</body>
<script>
	$('a.btn_editprod').click(function(){
		$('#container_modal').load("core/productos/form_edit_productos.php");
	})
	$('#btn_addtalla').click(function(){
		$('#container_modal').load("core/tallas/form_create_talla.php");
	})
</script>
</html>