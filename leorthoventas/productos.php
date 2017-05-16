<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/style.css">
	<link rel="stylesheet" href="css/fonts.css">
	<script type="text/javascript" src="js/script.js"></script>
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
			<table>
				<tr>
					<td class="tit_col">Producto</td>
					<td class="tit_col">Talla</td>
					<td class="tit_col">Precio</td>
					<td class="tit_col">Disponibles</td>
				</tr>
				<tr>
				<td class="campo"></td>
				<td class="campo"></td>
				<td class="campo"></td>
				<td class="campo"></td>
				</tr>
			</table>
		</div>
		<div id="apdos">
			<div id="divprods2">
				<label for="">Productos por agotarse</label>
				<table>
					<tr>
						<td class="tit_col">Descripción</td>
						<td class="tit_col">Disponibles</td>
					</tr>
					<tr>
						<td class="camposwar">Muñequera</td>
						<td class="camposwar">2</td>
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
</body>
</html>