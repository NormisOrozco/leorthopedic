<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/style.css">
	<link rel="stylesheet" href="css/fonts.css">
	<script type="text/javascript" src="js/script.js"></script>
	<title>VENTAS LEORTHOPEDIC</title>
</head>
<body>
<nav>
	<?php
	require_once("menu.php");
	?>
</nav>
	<div class="divtop">
		<label for="">ENTRADAS - LEORTHOPEDIC</label>
	</div>
	<form action="" id="form_ent">
	<table>
		<tr>
			<th>Código</th>
			<th>Cantidad</th>
			<th>Costo</th>
			<th>Observaciones</th>
		</tr>
		<tr>
			<td><input type="text" class="campo_in"></td>
			<td><input type="text" class="campo_in"></td>
			<td><input type="text" class="campo_in"></td>
			<td><input type="text" class="campo_in"></td>
			<td><div class="boton"  id="btn_acept" onclick=""><span class="icon-agregar"></span>Aceptar</td></div>
			
		</tr> 
	</table>
	</form>
	<hr>
	<div id="divent">
		<table>
		<tr>
			<th class="tit_col">Producto</th>
			<th class="tit_col">Cantidad</th>
			<th class="tit_col">Fecha</th>
			<th class="tit_col">Observaciones</th>
			<th class="tit_col" id="col_acc">Acciones</th>
		</tr>
			<th class="campo"><label></label></th>
			<th class="campo"><label></label></th>
			<th class="campo"><label></label></th>
			<th class="campo"><label></label></th>
			<th><div class="btn_deta" onclick=""><span class="botones icon-info"></span>Detalles</td></div></th>
		</table>
	</div>
</body>
</html>