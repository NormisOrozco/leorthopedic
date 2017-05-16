<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/style.css">
	<link rel="stylesheet" href="css/fonts.css">
	<script type="text/javascript" src="js/script.js"></script>
	<script type="text/javascript" src="js/jquery.validate.js"></script>
	<title>GASTOS EXTRAS</title>
</head>
<body>
<body>
<nav>
	<?php
	require_once("menu.php");
	?>
</nav>
 	<div class="divtop"><label for="">GASTOS</label></div>
 	<div id="divgastos">
		<label class="titcol">Concepto</label>
		<form id="formuno" name="form1" method="post" action="">
			<select id="concepto" type="text" onchange="">
				<option value="1">Cambio</option>
				<option value="2">Personales</option>
			</select>
			<label class="titcol">Valor</label>
			<input type="text" name="Valor">
			<label class="titcol">Descripción</label>
			<textarea id="ta_gastos">  </textarea>
			<button class="boton"><span class="icon-agregar"></span>Aceptar</button>
		</form>
	</div>
</body>
</html>